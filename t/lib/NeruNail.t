use strict;
use warnings;
use lib 'lib';

use Test::More;

BEGIN {
    use_ok('NeruNail');
}

subtest get_pic => sub {
    my $params = {
        base_image => 'hogehoge',
    };
    my $result = NeruNail->get_pic($params);
    ok($result);
};

done_testing;
