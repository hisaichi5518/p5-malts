use strict;
use warnings;

package HelloMalts;
use parent qw(Malts);

sub dispatch {
    my $self = shift;
    $self->create_response(200, [], ['Hello Malts!']);
}

=pod

dispatchメソッドでresponseオブジェクトを返すだけ。

=cut

package main;

HelloMalts->to_app;

__END__

=pod

=head1 NAME

hello.psgi - Malts最小構成

=cut
