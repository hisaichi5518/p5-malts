use Mojolicious::Lite;

get '/' => sub {
    $_[0]->render(text => "ok");
};

app->start;
