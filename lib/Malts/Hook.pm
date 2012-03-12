package Malts::Hook;
use 5.10.1;
use strict;
use warnings;
use Exporter 'import';
use Malts::Util;
use Log::Minimal qw(debugf);
our @EXPORT = qw(hook);

sub hook {
    state $hook = Malts::Hook->new;
}

sub new { bless {hooks => {}}, shift }

sub hooks {
    hook->{hooks};
}

sub set {
    my ($self, $hook_name, $hook_code) = @_;
    if (!exists hooks->{$hook_name}) {
        hooks->{$hook_name} = [$hook_code];
        return 1;
    }

    push @{hooks->{$hook_name}}, $hook_code;
    return 1;
}

sub get {
    my ($self, $hook_name) = @_;
    return hooks->{$hook_name};
}

sub run {
    my ($self, $hook_name, @args) = @_;
    my $hook_codes = $self->get($hook_name) or return;
    Malts::Util::DEBUG && debugf "Run $hook_name hooks.";

    for my $code (@$hook_codes) {
        $code->(@args);
    }
}

sub reset {
    my ($self, $hook_name) = @_;
    delete hooks->{$hook_name};
}

sub reset_all {
    my ($self) = @_;
    $self->{hooks} = {};
}

1;
__END__

=encoding utf8

=head1 NAME

Malts::Hook - hooks for Malts

=head1 SYNOPSIS

    package MyApp::Plugin::Hoge;
    use strict;
    use warnings;
    use Malts::Hook;

    hook->set(after_dispatch => sub {
        my ($c, $res) = @_;
        $res->body("pero-pero");
    });

    1;

=head1 METHODS

=head2 C<< hook() -> Object >>

    $hook = hook(); #=> Malts::Hook->new();

C<use Malts::Hook;>するとimportされます。

=head2 C<< Malts::Hook->new() -> Object >>

    $hook = Malts::Hook->new();

=head2 C<< hook->hooks -> HashRef >>

    hook->hooks;

フックの一覧を返します。

=head2 C<< hook->set($hook_name => \&hook_code) >>

    hook->set('after_dispatch' => sub {
        ...;
    });

フックを追加します。

C<$hook_name>は、...。

=head2 C<< hook->get($hook_name) -> ArrayRef >>

    my $hook_codes = hook->get('after_dispatch');

C<$hook_name>に一致するフックコードを返します。

=head2 C<< hook->run($hook_name[, @args]) >>

    hook->run('after_dispatch');

C<$hook_name>が一致するフックを実行します。

=head2 C<< hook->reset($hook_name) >>

C<$hook_name>のフックを削除する。

=head2 C<< hook->reset_all() >>

全てのフックを削除する。

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
