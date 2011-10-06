package HelloApp::Model::Dice;
use strict;
use warnings;

sub new {bless {}, shift}

sub shake {
    return int(rand(5)) + 1;
}

package HelloApp::Web::Controller::Root;
use strict;
use warnings;

# HACK for Plack::Util::load_class()
$INC{'HelloApp/Web/Controller/Root.pm'} = __FILE__;

sub index {
    my ($self, $c) = @_;
    my $dice = HelloApp::Model::Dice->new(user => 'hisaichi');
    my $dice_num = $dice->shake;
    $c->render('root/index.tx', {user => $dice->{user}, dice_num => $dice_num});
}

package HelloApp;
use strict;
use warnings;
use parent 'Malts';

sub startup {
    # CLI, Web共通のプラグインなど
}

package HelloApp::Web;
use strict;
use warnings;

use parent -norequire, 'HelloApp';
use parent 'Malts::Web';
use Text::Xslate;
use Class::Method::Modifiers::Fast;

after startup => sub {
    my $self = shift;

    $self->view(Text::Xslate->new(
        path => {'root/index.tx' => '<: $user :> DICE: <: $dice_num :>'}
    ));

    my $r = $self->routes('RSimple');
    $r->connect('/' => {controller => 'Root', action => 'index'});
};

package main;
use strict;
use warnings;

use Plack::Builder;

builder {
    enable "Plack::Middleware::Log::Minimal", autodump => 1;

    HelloApp::Web->to_app;
};
