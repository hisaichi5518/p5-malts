package MyApp::Web;
use strict;
use warnings;
use Kossy;
use File::Basename;

get '/' => sub {
    my ( $self, $c )  = @_;
    $c->res->status(200);
    $c->res->body('ok');
    $c->res;
};

my $root_dir = File::Basename::dirname(__FILE__);
my $app = MyApp::Web->psgi($root_dir);
