package Malts::Setup::Command::init;
use strict;
use warnings;
use parent 'Malts::Setup::Command';
use Malts::Setup::Module;
use Malts::Setup::Template;

sub run {
    my $class = shift;
    my ($opts, @args) = $class->parse_options(@_);

    my $template = Malts::Setup::Template->new(name => $args[1]);
    my $module   = Malts::Setup::Module->new(
        name     => $args[0],
        template => $template,
    );

    die "!! exists ".$module->dist if -e $module->dist && !$opts->{force};

    my $files = $module->build_template_files;
    $class->create_files($files, {
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
