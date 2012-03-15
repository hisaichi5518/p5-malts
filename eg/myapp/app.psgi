use strict;
use warnings;
use lib "./lib";
use Plack::Builder;
use HelloApp::Web;

builder {
    enable "Plack::Middleware::Log::Minimal", autodump => 1;

    HelloApp::Web->to_app;
};
