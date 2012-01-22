package HelloApp::Web::Controller::Root;

use strict;
use warnings;
use HelloApp::Model::Dice;

sub index {
    my ($self, $c) = @_;
    my $dice = HelloApp::Model::Dice->new(user => 'hisaichi');
    my $dice_num = $dice->shake;
    $c->res_200('root/index.tx', {dice_user => $dice->{user}, dice_num => $dice_num});
}

1;
