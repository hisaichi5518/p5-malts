package Malts::Hook;
use strict;
use warnings;
use Malts::Util;
use Log::Minimal qw(debugf);

my $hook;
sub set {
    my ($self, $hook_name, $hook_code) = @_;
    if (!exists $hook->{$hook_name}) {
        $hook->{$hook_name} = [$hook_code];
        return 1;
    }

    push @{$hook->{$hook_name}}, $hook_code;
    return 1;
}

sub get {
    my ($self, $hook_name) = @_;
    return $hook->{$hook_name};
}

sub run {
    my ($self, $hook_name, @args) = @_;
    my $hook_codes = $self->get($hook_name) or return;
    Malts::Util::DEBUG && debugf "Run $hook_name hooks.";

    for my $code (@$hook_codes) {
        $code->(@args);
    }
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

    sub init {
        my ($self, $c) = @_;
        Malts::Hook->set('after_dispatch' => sub {
            my ($c, $res) = @_;
            $res->body("pero-pero");
        });
    }

    1;

=head1 METHODS

=head2 C<< Malts::Hook->set($hook_name => \&hook_code) >>

    Malts::Hook->set('after_dispatch' => sub {
        ...;
    });

C<$hook_name>は、...。

=head2 C<< Malts::Hook->get($hook_name) -> ArrayRef >>

    my $hook_codes = Malts::Hook->get('after_dispatch');

C<$hook_name>に一致するコードを返します。

=head2 C<< Malts::Hook->run($hook_name[, @args]) >>

    Malts::Hook->run('after_dispatch');

C<$hook_name>が一致するhookを実行します。

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
