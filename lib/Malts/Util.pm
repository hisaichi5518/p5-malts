package Malts::Util;
use strict;
use warnings;
use Plack::Util ();
use constant DEBUG => (($ENV{PLACK_ENV} || 'development') eq 'development' ? 1 : 0);

1;
__END__

=head1 NAME

Malts::Util - Utility subroutines for Malts and Malts user

=head1 SYNOPSIS

    use Malts::Util;
    warn 'debug!' if Malts::Util::DEBUG;
    my $class = Plack::Util::load_class('Hoge');

=head1 Functions

L<Malts::Util>の中で、L<Plack::Util>をuseしているのでL<Malts::Util>をuseするとL<Plack::Util>も使えるようになります。

=head2 C<DEBUG>

    warn '$ENV{PLACK_ENV} is development!'
        if Malts::Util::DEBUG;

$ENV{PLACK_ENV}がdevelopmentの時に1を返します。

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<Plack::Util>

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
