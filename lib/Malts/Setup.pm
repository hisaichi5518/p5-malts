package Malts::Setup;
use strict;
use warnings;
use Plack::Util;

sub run {
    my ($class, $command, @args) = @_;
    $command = 'help' if not defined $command;
    $command = Plack::Util::load_class($command, 'Malts::Setup::Command');
    $command->run(@args);
}

1;
__END__

=head1 METHODS

=head2 C<< $class->run($subcommand, @args) >>

    Malts::Setup->run(
        'init' => qw/--dry-run Hoge/,
    );

=cut
