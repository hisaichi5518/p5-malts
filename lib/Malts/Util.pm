package Malts::Util;
use strict;
use warnings;
use Plack::Util ();
use Encode ();
use Carp ();
use Plack::MIME;
use constant DEBUG => (
    ($ENV{PLACK_ENV} || 'development') eq 'development' ? 1 : 0
);

sub find_encoding {
    my ($encoding) = @_;
    my $enc = Encode::find_encoding($encoding)
        or Carp::croak("encoding '$encoding' not found.");

    return $enc;
}

# Plack::App::DataSection
sub is_binary {
    my ($file_name) = @_;
    my $type = Plack::MIME->mime_type($file_name) or return;
    $type !~ /\b(?:text|xml|javascript|json)\b/;
}

sub remove_fileline {
    my ($message) = @_;

    $message =~ s/(?:.+ called)? at .+? line \d+\.?\n?//g;
    return $message;
}

1;
__END__

=head1 NAME

Malts::Util - Utility subroutines for Malts and Malts user

=head1 SYNOPSIS

    use Malts::Util;
    warn 'debug!' if Malts::Util::DEBUG;
    Malts::Util::find_encoding('utf8');

=head1 FUNCTIONS

=head2 C<< DEBUG -> Bool >>

Returns 1 if I<$ENV{PLACK_ENV}> is development.

=head2 C<< find_encoding($encoding) -> Object >>

Create a encoding object using Encode::find_encoding($encoding).

=head2 C<< is_binary($file_name) -> Bool >>

Returns true if I<$file_name> is binary.

=head2 C<< remove_fileline($error_message) >>

Remove error line.

    print remove_error_line('ERROR at lib/Malts.pm line 5.'); #=> prints "ERROR"

=cut
