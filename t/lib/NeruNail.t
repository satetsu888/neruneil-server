use strict;
use warnings;
use lib 'lib';

use Test::More;

BEGIN {
    use_ok('NeruNail');
}

subtest get_pic => sub {
    my $image_hash = '00866c4e3befd494ac67d85fe0120e60';
    my $offset = 0;
    my $limit = 10;
    my $params = {
        base_image_hash => $image_hash,
        offset          => $offset,
        limit           => $limit,
    };
    my $result = NeruNail->get_pic($params);
    ok($result);
    isa_ok($result, 'ARRAY');
    is(scalar @{$result}, $limit, 'expected length');
};

done_testing;
