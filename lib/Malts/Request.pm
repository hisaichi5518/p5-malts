package Malts::Request;
use strict;
use warnings;
use parent 'Plack::Request';

1;
__END__

=encoding utf8

=head1 NAME

Malts::Request - Malts用のRequestクラス

=head1 SYNOPSIS

    use Malts::Request;
    my $env = {PATH_INFO => '/'};
    my $req = Malts::Request->new($env);
    $req->path_info;

=head1 DESCRIPTION

L<Plack::Request>を継承している。

=head1 SEE ALSO

L<Plack::Request>

=cut
