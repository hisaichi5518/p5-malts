package Malts::Plugin::Web::View::JSON;
use strict;
use warnings;
use JSON 2 qw/encode_json/;

my $JSON   = JSON->new->ascii(1);
my %ESCAPE = (
    '+' => '\\u002b', # do not eval as UTF-7
    '<' => '\\u003c', # do not eval as HTML
    '>' => '\\u003e', # ditto.
);

sub init {
    my ($class, $c) = @_;
    $c->add_method(render_json => \&_render_json);
}

sub _render_json {
    my ($c, $status, $stuff) = @_;
    my $output   = $JSON->encode($stuff);
    my $res      = $c->create_response($status);
    my $encoding = lc $c->encoding->mime_name;
    my $ua       = $c->request->user_agent || '';

    $output =~ s!([+<>])!$ESCAPE{$1}!g;
    # add UTF-8 BOM if the client is Safari
    if ($ua =~ m/Safari/ and $encoding eq 'utf-8') {
        $output = "\xEF\xBB\xBF" . $output;
    }

    $res->headers($c->create_headers($output));
    # content_type
    if (
        $ua =~ /Chrome/ and
        ($c->request->env->{'HTTP_X_REQUESTED_WITH'} || '') ne 'XMLHttpRequest'
    ) {
        $res->content_type("text/html; charset=$encoding");
    }
    else {
        $res->content_type("application/json; charset=$encoding");
    }

    $res->body($output);

    return $res;
}

1;
__END__

=encoding utf8

=head1 FUNCTIONS

=head2 C<< $c->render_json($status, $stuff) >>

=head2 C<< $class->init >>

=head1 SEE ALSO

# Amon2からほぼコピペ
# * IE7 JSON venularity.
# http://www.atmarkit.co.jp/fcoding/articles/webapp/05/webapp05a.html

# * application/json
# http://blog.flatlabs.net/20110304_231535/
# http://d.hatena.ne.jp/a666666/20090310/1236664380
# http://suika.fam.cx/~wakaba/wiki/sw/n/application+json

=cut
