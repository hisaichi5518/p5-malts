package Malts::CLI;
use strict;
use warnings;

use Malts::Util ();
use Log::Minimal qw(debugf croakf);

sub run {
    my ($class, $command, @args) = @_;
    Malts::Util::DEBUG && local $ENV{$Log::Minimal::ENV_DEBUG} = Malts::Util::DEBUG;
    local $Log::Minimal::COLOR    = 1;
    local $Log::Minimal::AUTODUMP = 1;

    croakf("usage: $0 subcommand [--options, ...][args, ...]") if not defined $command;
    my $self = $class->new;

    Malts::Util::DEBUG && debugf("do $class->startup!");
    $self->startup;

    my $subcommand = {$self->alias}->{$command} || $command;
    if (ref $subcommand ne 'CODE') {
        my $subcommand_class = Plack::Util::load_class($subcommand, ref($self).'::Command');

        $self->parse_options(
            option_spec  => [$subcommand_class->option_spec],
            pass_through => $subcommand_class->pass_through || 0,
            args => \@args
        );

        if (Malts::Util::DEBUG) {
            debugf('options: %s', $self->options || {});
            debugf('args: %s', $self->args || []);
            debugf("do $subcommand_class->run");
        }
        $subcommand_class->run($self);
    }
    else {
        if (Malts::Util::DEBUG) {
            debugf("alias $command => %s", $subcommand);
            debugf('Do you want to use $c->options or $c->args? do $c->parse_options(...)!');
            debugf('run command.');
        }
        $subcommand->($self, \@args);
    }
}

sub default_options {
    return (
        "posix_default",
        "permute",
        "no_ignore_case",
        "bundling",
    );
}

sub parse_options {
    my($self, %options) = @_;

    my @args         = @{$options{args}};
    my @spec         = @{$options{option_spec}};
    my $pass_through = $options{pass_through};

    require Getopt::Long;
    my $old = Getopt::Long::Configure(
        $self->default_options,
        ($pass_through ? "pass_through" : ()),
    );

    my %opts;
    my $success = Getopt::Long::GetOptionsFromArray(\@args, \%opts, @spec);

    Getopt::Long::Configure($old);

    if(!$pass_through and !$success) {
        return;
    }
    $self->{options} = \%opts;
    $self->{args}    = \@args;

    return 1;
}

sub alias   { return ()        }
sub args    { shift->{args}    || [] }
sub options { shift->{options} || {} }

1;
__END__

=head1 NAME

Malts::CLI - 次世代 CLI Application Framework

=head1 SYNOPSIS

    pacakage MyApp;
    use strict;
    use warnings;
    use parent 'Malts';

    package MyApp::CLI;
    use strict;
    use warnings;
    use parent -norequire, 'MyApp';
    use parent 'Malts::CLI';
    use Class::Method::Modifiers::Fast qw(after);

    after startup => sub {
        my $self = shift;
        ...
    };

    sub alias {
        return (
            k    => 'kuso', # alias MyApp::CLI::Command::kuso
            h    => \&help,
            help => \&help,
        );
    }

    sub help {
        my ($self, @args) = @_;
        print "./script/myapp help\n";
    }

=head1 DESCRIPTION

=head1 METHODS

=head2 C<< $c->alias >>

    package MyApp::CLI;
    use parent qw(Malts Malts::CLI);
    sub alias {
        return (
            m => 'meta',
            help_me => sub { print "help me!\n" }
        );
    }

=head2 C<< $c->args >>

    my $args = $c->args;

=head2 C<default_options>

    my @default_options = $c->default_options;

=head2 C<< $c->options >>

    my $options = $c->options;

=head2 C<< $c->parse_options(%args) >>

    $c->parse_options(
        option_spec  => \@option_spec,
        pass_through => $pass_through,
        args => \@args,
    );

C<$c->options>とC<$c->args>にそれぞれ突っ込まれる。

=head2 C<< $class->run >>

    MyApp::CLI->run(@ARGV);

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
