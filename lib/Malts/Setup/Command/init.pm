package Malts::Setup::Command::init;
use strict;
use warnings;
use parent 'Malts::Setup::Command';
use Malts::Setup::Module;
use Malts::Setup::Flavor;

sub run {
    my $class = shift;
    my ($opts, @args) = $class->parse_options(@_);

    my $module = Malts::Setup::Module->new(name => $args[0]);
    my $flavor = Malts::Setup::Flavor->new(name => $args[1]);

    die "!! exists ".$module->dist if -e $module->dist && !$opts->{force};

    my $files = $module->build_files($flavor->files);
    $class->create_files($files, {
        prefix  => $module->name,
        dry_run => $opts->{'dry-run'},
    });
}

sub option_spec {
    qw/dry-run force/;
}

1;
__END__

=head1 METHODS

=head2 C<< $class->run >>

=head2 C<< $class->option_spec >>

=cut
