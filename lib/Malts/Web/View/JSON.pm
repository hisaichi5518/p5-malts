package Malts::Web::View::JSON;
use strict;
use warnings;

use JSON 2 qw/encode_json/;
use Exporter 'import';
our @EXPORT_OK = qw(render_json);

my $JSON   = JSON->new->ascii(1);
my %ESCAPE = (
    '+' => '\\u002b', # do not eval as UTF-7
    '<' => '\\u003c', # do not eval as HTML
    '>' => '\\u003e', # ditto.
);

sub render_json {
    my ($c, $status, $stuff) = @_;

    # for IE7 JSON venularity.
    # see http://www.atmarkit.co.jp/fcoding/articles/webapp/05/webapp05a.html
    my $output = $JSON->encode($stuff);
    $output =~ s!([+<>])!$ESCAPE{$1}!g;

    my $res = $c->create_response($status);

    my $encoding = $c->encoding;
    $encoding = lc $encoding->mime_name;

    my $ua = $c->request->user_agent || '';
    # chrome bug
    if ($ua =~ /Chrome/ and ( $c->request->env->{'HTTP_X_REQUESTED_WITH'} || '' ) ne 'XMLHttpRequest') {
        $res->content_type("text/html; charset=$encoding");
    }
    else {
        $res->content_type("application/json; charset=$encoding");
    }
    # Operaはx-javascript ?

    # add UTF-8 BOM if the client is Safari
    if ($ua =~ m/Safari/ and $encoding eq 'utf-8') {
        $output = "\xEF\xBB\xBF" . $output;
    }

    $res->header('X-Content-Type-Options' => 'nosniff'); # defense from XSS
    $res->content_length(length $output);
    $res->body($output);

    return $res;
}

1;
__END__

=encoding utf-8

=head1 NAME

Malts::Web::JSON - JSON plugin

=head1 SYNOPSIS

    package MyApp::Web;
    use parent qw(Malts Malts::Web);
    use Malts::Web::View::JSON;

    sub res_200 {
        my ($c, $data) = @_;
        $c->render_json(200, $data);
    }

=head1 DESCRIPTION

This is a JSON plugin for L<Malts>.

=head1 METHODS

=head2 C<< $c->render_json($status, \%data) >>

    my $res = $c->render_json(200, {name => 'hisaichi5518'});

=head1 SEE ALSO

L<Amon2::Plugin::Web::JSON>

=head1 BASE CODE

L<Amon2::Plugin::View::JSON> by tokuhirom

=cut
