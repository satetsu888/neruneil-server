use strict;
use warnings;
use lib 'lib';

use Test::More;

BEGIN {
    use_ok('NeruNail::ImageSearcher::DRE');
}

subtest call => sub {
    my $image_hash = '00866c4e3befd494ac67d85fe0120e60';

    my $result = NeruNail::ImageSearcher::DRE->call(+{ image_hash => $image_hash });

    ok($result, 'got some result');
    isa_ok($result, 'ARRAY');
    ok( exists $result->[0]->{url}, 'result contains url');
    ok( exists $result->[0]->{distance}, 'result contains distance');
};

done_testing;
