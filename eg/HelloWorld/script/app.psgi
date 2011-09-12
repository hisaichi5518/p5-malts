package HelloWorld;
use strict;
use warnings;
use parent 'Malts';

package HelloWorld::Web::Controller::Root;
use strict;
use warnings;

# HACK for Plack::Util::load_class()
$INC{'HelloWorld/Web/Controller/Root.pm'} = __FILE__;

sub begin {
    my ($self, $c) = @_;
    # actionが実行される前に何か処理を加えたい場合ここに追加する。
    # このメソッドは削除しても正常に動作する。
}

sub end {
    my ($self, $c) = @_;
    # actionが実行された後に何か処理を加えたい場合ここに追加する。
    # このメソッドは削除しても正常に動作する。
}

sub index {
    my ($self, $c) = @_;
    $c->ok('ok');
}

package HelloWorld::Web;
use strict;
use warnings;

use parent -norequire, 'HelloWorld';
use parent 'Malts::Web';
use Class::Method::Modifiers::Fast qw(after);

after startup => sub {
    my $self = shift;
    my $r = $self->routes('RSimple');
    $r->connect('/' => {controller => 'Root', action => 'index'});
};

package main;
use strict;
use warnings;

HelloWorld::Web->to_app;
