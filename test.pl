#!/usr/bin/perl

use JSON::XS;
use URI;
use Data::Dumper;
use List::MoreUtils qw/ uniq /;

my $key = 'ネイル';
my @all_image_urls = ();


for(1..5){
    my ($image_urls, $next_url) = get_response_from_api_url( built_api_url($key, $_) );
    push @all_image_urls, @$image_urls;
}

@all_image_urls = uniq @all_image_urls;

warn Data::Dumper::Dumper \@all_image_urls;


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
