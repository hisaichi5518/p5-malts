package Malts::Response;
use strict;
use warnings;
use parent 'Plack::Response';

1;
__END__

=encoding utf8

=head1 NAME

Malts::Response - Malts用のResponseクラス

=head1 SYNOPSIS

    use Malts::Response;
    my $res = Malts::Response->new(200);
    $res->content_type('text/html; charset=UTF-8');
    $res->body('Hello Malts World!');

=head1 DESCRIPTION

L<Plack::Response>を継承している。

詳しくは、L<Plack::Response>を参照。

=head1 SEE ALSO

L<Plack::Response>

=cut
