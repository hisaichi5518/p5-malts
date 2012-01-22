package HelloApp::Model::Dice;

use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub shake {
    return int(rand(5)) + 1;
}

1;
