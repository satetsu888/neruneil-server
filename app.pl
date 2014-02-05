use strict;
use warnings;
use utf8;
use lib 'lib';

use Mojolicious::Lite;
use MojoX::JSON::RPC::Service;
use NaruNail;

my $svc = MojoX::JSON::RPC::Service->new;

$svc->register(
    'get_pic',
    sub {
        my $params = shift;
        return NaruNail->get_pic($params);
    },
);

plugin 'json_rpc_dispatcher' => {
    services => {
        '/jsonrpc' => $svc,
    }
};

get '/' => sub {
    my $self = shift;
    $self->render();
} => 'index';

app->start;

__DATA__
@@ index.html.ep
<html>
<head></head>
<body>Hello</body>
</html>
