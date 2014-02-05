use strict;
use warnings;
use lib 'lib';

use Test::More;

BEGIN {
    use_ok('NeruNail::ImageSearcher::DRE');
}

subtest call => sub {
    use Data::Dumper;

    my $result = NeruNail::ImageSearcher::DRE->call();
    warn Data::Dumper::Dumper $result;
    ok(1);
};

done_testing;
