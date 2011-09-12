package Malts::CLI;
use strict;
use warnings;

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

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
