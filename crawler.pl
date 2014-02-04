#!/usr/bin/perl

use JSON::XS;
use URI;
use Data::Dumper;
use List::MoreUtils qw/ uniq /;
use Digest::MD5 qw/ md5_hex /;

use constant {
    NUM_OF_LARGE_RESULT => 8,
};

my @all_image_urls = ();
my @keys = ();
my $SAVE_DIR_PATH  = './images/';
my $MAX_FILE_SIZE  = '1000000';
my $TIMEOUT        = 5;
my $MAX_RETRY      = 2;

my $base_key = 'ネイル';
my @sub_keys = qw/ 赤 青 黄色 緑 バレンタイン クリスマス かわいい カワイイ /;
my $number_of_page = 5;

for(@sub_keys){
    push @keys, $base_key.' '.$_;
}

for my $key (@keys){
    for(0..$number_of_page - 1){
        my ($image_urls, $next_url) = get_response_from_api_url( built_api_url($key, $_ * NUM_OF_LARGE_RESULT) );
        push @all_image_urls, @$image_urls;
    }
}

@all_image_urls = uniq @all_image_urls;
for (@all_image_urls){
    down_load_file($_);
}

exit;

sub get_response_from_api_url {
    my $api_url = shift;
    my @image_urls;

    my $res = `curl "$api_url"`;
    warn $api_url;
    my $json_res = decode_json($res);
    my @image_urls = map {
        $_->{url};
    } @{$json_res->{responseData}->{results}};

    my $nextUrl = $json_res->{responseData}->{cursor}->{moreResultsUrl};

    return \@image_urls, $nextUrl;

}

sub built_api_url {
    my ($key, $index) = @_;
    my $uri = URI->new('http://ajax.googleapis.com/ajax/services/search/images');
    $uri->query_form(
        v       => '1.0',
        rsz     => 'large',
        imgc    => 'color',
        imgtype => 'photo',
        start   => $index,
        q       => $key,
    );

    warn $uri->as_string;
    return $uri->as_string;
}

sub down_load_file {
    my $url = shift;
    my $file_name = $SAVE_DIR_PATH.md5_hex($url . int rand 0xFFFF);

    `wget -O "$file_name" -Q $MAX_FILE_SIZE -T $TIMEOUT -t $MAX_RETRY "$url"`;
    unlink $file_name if -s "$file_name" <= 0;

}
