use strict;
use warnings;

use Test::More;
use JSON::XS;

subtest get_pic => sub {
    my $result = `curl -X POST -d '{"jsonrpc": "2.0", "method": "get_pic", "params": { "base_image_hash": "2144d9a8b080f38dbd0f07c4cdeaaa04", "offset":0, "limit": 10}, "id": 1}' http://localhost:3000/jsonrpc`;

    my $result_json = decode_json($result);

    ok(exists $result_json->{jsonrpc});
    ok(exists $result_json->{id});
    ok(exists $result_json->{result});
    isa_ok($result_json->{result}, 'ARRAY');
};

done_testing;

