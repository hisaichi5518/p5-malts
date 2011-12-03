package Malts::Plugin::ConfigLoader;
use strict;
use warnings;

use File::Spec ();
use Log::Minimal qw(croakff);
use Scope::Container qw(scope_container);

sub init {
    my ($class, $c, $opts) = @_;

    my $mode = $opts->{mode} || $ENV{PLACK_ENV} || 'development';
    my $fname = File::Spec->catfile($c->app_dir, 'config', "$mode.pl");
    my $config = do $fname or croakff "Cannot load configuration file: $fname";
    scope_container(config => $config);
}

1;
__END__

=pod

=head1 METHOD

=head2 C<< $class->init($c, $opts) >>

    Malts::Plugin::ConfigLoader->init($c, $opts);

app_dir/config以下に設定ファイルを置く。

設定ファイル名は、$ENV{PLACK_ENV}またはオプションのmodeで指定する。

何も指定されていない場合は、development.plが読み込まれる。

=cut
