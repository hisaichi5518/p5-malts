package Malts::ConfigLoader;
use strict;
use warnings;
use Exporter 'import';
use File::Spec ();
use Log::Minimal qw(croakff debugf);
use Malts::Util;

sub load {
    my $self = shift;
    my $fname = File::Spec->catfile(@_);
    Malts::Util::DEBUG && debugf "Load Config File: $fname";
    do $fname or croakff "Cannot load configuration file: $fname";
}

1;
__END__

=pod

=head1 METHOD

=head2 C<< Malts::ConfigLoader::load(@config_path) -> HashRef >>

    sub config {
        state $config = do {
            my @config_path = ($_[0]->app_dir, 'config', 'config.pl');
            Malts::ConfigLoader->load(@config_path);
        };
    }

=cut
