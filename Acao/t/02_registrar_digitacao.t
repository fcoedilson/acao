use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;

BEGIN { use_ok 'Catalyst::Test', 'Acao' }

my $res = request POST '/login', [ user => 'ciclano', password => '12345', ];

is( $res->code, 302, 'Quando a autenticação é bem sucedida, ele faz um redirect');
is( $res->header('Location'), 'http://localhost/auth', 'Ele manda para a área autenticada' );
ok( $res->header('Set-Cookie'), 'A autenticação definiu o Cookie');

my $sess_cicl = $res->header('Set-Cookie');

$res = request GET('/auth/registros/digitador/', Cookie => $sess_cicl);
is( $res->code, 200, 'Apresentando lista de cadastros' );

my $content = $res->content;
while ($content =~ m{href="http://localhost(/auth/registros/digitador/([^"]+))}gis) {
    $res = request GET($1, Cookie => $sess_cicl);
    is( $res->code, 200, 'Acessando cadastro ' . $2);

    
}

done_testing();



