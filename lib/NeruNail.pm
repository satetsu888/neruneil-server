package NeruNail;
use strict;
use warnings;
use utf8;
use lib 'lib';

use NeruNail::ImageSearcher::DRE;

sub get_pic {
    my $class = shift;
    my $param = shift;

    # TODO: validation
    my $base_image_hash = $param->{base_image_hash};
    my $offset = $param->{offset};
    my $limit = $param->{limit};

    # TODO: make factory class
    my $searcher = NeruNail::ImageSearcher::DRE->new();
    my $response = $searcher->call(
        +{
            image_hash => $base_image_hash,
        }
    );

    return [ @{$response}[$offset..$offset + $limit - 1 ] ];
}

1;
