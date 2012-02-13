package Malts::ConfigLoader;
use strict;
use warnings;
use Exporter 'import';
use File::Spec ();
use Log::Minimal qw(croakff debugf);
use Malts::Util;
use Hash::Util ();

sub load {
    my $self = shift;
    my $fname = File::Spec->catfile(@_);
    Malts::Util::DEBUG && debugf "Load Config File: $fname";
    my $config = do $fname or croakff "Cannot load configuration file: $fname";
    lock_data($config);
    return $config;
}

sub lock_data {
    my ($value) = @_;
    my $type = ref $value;
    if (defined($type) and $type eq 'HASH') {
        lock_hashref($value);
    }
    elsif (defined($type) && $type eq 'ARRAY') {
        lock_arrayref($value);
    }
}

sub lock_hashref {
    my $hash = shift;

    Hash::Util::lock_ref_keys($hash);
    foreach my $v (values %$hash) {
        lock_data($v);
        Internals::SvREADONLY($v, 1);
    }
}

sub lock_arrayref {
    my ($value) = @_;

    for my $v (@$value) {
        lock_data($v);
        Internals::SvREADONLY $v, 1;
    }
}

1;
__END__

=pod

=head1 METHOD

=head2 C<< Malts::ConfigLoader->load(@config_path) -> HashRef >>

    sub config {
        state $config = do {
            my @config_path = ($_[0]->app_dir, 'config', 'config.pl');
            Malts::ConfigLoader->load(@config_path);
        };
    }

設定ファイルを指定して設定のデータを取得します。

このメソッドを介して受け取った設定データは一切変更出来ません。

=head2 C<< $self->lock_data(\%hash or \@array); >>

    $self->lock_data(\%hash);

ハッシュリファレンス、配列のリファレンスを変更不可にします。

=head2 C<< $self->lock_hashref() >>

    $self->lock_hashref(\%hash);

ハッシュリファレンスを変更不可にします。

L<Hash::Util>のC<lock_hash_recurse>と違う部分は配列のリファレンスも変更不可にするところです。

=head2 C<< $self->lock_arrayref(\@array) >>

    $self->lock_arrayref(\@array);

配列のリファレンスを変更不可にします。

=head1 SEE ALSO

L<Hash::Util>

=cut
