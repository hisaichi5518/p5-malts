package Malts;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

1;
__END__

=encoding utf8

=head1 NAME

Malts - 次世代 Web Application Framework

=head1 SYNOPSIS

    package MyApp::Web;
    use strict;
    use warnings;
    use parent 'Malts';

    sub startup {
        my $self = shift;
        $self->create_response(200, [], ['Hello, World!']);
    }

=head1 DESCRIPTION

Malts is ...!

=head1 METHODS

=head2 C<method_name>

    $c->method_name

説明

=head1 SEE ALSO

L<Plack>

=head1 Repository

  http://github.com/hisaichi5518/p5-malts

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
