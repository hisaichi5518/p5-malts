package Malts::Web::Flash;
use strict;
use warnings;
use Malts::Hook;
use Exporter 'import';
use Log::Minimal;

our @EXPORT = qw/flash dump_flash/;

my $FLASH_KEY = '__flash';
my $FLASH_NEW_KEY = $FLASH_KEY.'_new';

hook->set(before_dispatch => sub {
    my ($c) = @_;
    my $session = $c->req->session;
    my $val = $session->get($FLASH_NEW_KEY);

    $session->remove($FLASH_KEY);
    $session->remove($FLASH_NEW_KEY);
    $session->set($FLASH_KEY, $val) if $val;
});

sub flash {
    my $c = shift;
    if (!@_) {
        croakf 'Usage: $c->flash($key => $value); or $c->flash($key);';
    }
    elsif (@_ == 1) {
        my $val = $c->req->session->get($FLASH_KEY);
        return $val ? $val->{$_[0]} : undef;
    }
    elsif (@_ == 2) {
        my ($key, $value) = @_;
        my $new_val = $c->req->session->get($FLASH_NEW_KEY) || {};
        $c->req->session->set($FLASH_NEW_KEY => {%$new_val, $key => $value});
        $c->req->session->set($FLASH_KEY => {
            %{$c->req->session->get($FLASH_KEY) || {}},
            %{$c->req->session->get($FLASH_NEW_KEY) || {}},
        });
    }
}

1;
__END__

=pod

=head1 METHODS

=head2 C<< $c->flash([$key, $value]) >>

    $c->flash(warn => 'ユーザーが見つかりませんでした');
    $c->flash('warn'); #=> ユーザーが見つかりませんでした

今のリクエストと次のリクエストでのみ参照出来るセッション

主にエラーメッセージや通知などを表示するのに使います。

=head1 TODO

- remove_flash
- remove_all_flash ?
- merge flash to session

=cut
