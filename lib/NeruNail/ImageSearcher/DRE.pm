package NeruNail::ImageSearcher::DRE;
use strict;
use warnings;

use XML::Simple;
use File::Basename;

my $BASE_COMMAND = 'java -jar dre.app.linux.x64.jar --package=lls --package-option="threshold=%d" --storage-path=%s --num-threads=%d %s';
my $BASE_IMAGE_URL = 'http://satetsu888.com/nail/images/';

sub new {
    my $class = shift;
    my %args = @_;

    return bless +{ %args }, $class;
};

sub call {
    my $self = shift;
    my $params = shift;

    my $raw_result = __call($params);
    my $result = __parse($raw_result);

    return $result;
}

sub __call {
    my $params = shift;
    my $command = sprintf(
        $BASE_COMMAND,
        400,
        'images',
        1,
        'images/' . $params->{image_hash},
    );

    return `$command`;
}

sub __parse {
    my $raw_result = shift;
    my @response_array = ();

    my $xs = XML::Simple->new();
    my $result = $xs->XMLin(
        $raw_result,
        KeyAttr => { simitem => 'file', file => 'id' }
    );

    my $simitem = $result->{simgroup}->{simitem};
    my $file    = $result->{file};

    for(keys $simitem){
        my $distance = $simitem->{$_}->{distance};
        my $path = $file->{$_}->{path};
        my $url = $BASE_IMAGE_URL . basename($path);
        push @response_array,
            +{
                distance => $distance,
                url      => $url,
            };
    }

    return [ sort { $a->{distance} <=> $b->{distance} } @response_array ];
}

1;
