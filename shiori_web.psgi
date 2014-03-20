#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Mojo::Server::PSGI;
use Plack::Builder;
use Shiori::Web;

my $psgi = Mojo::Server::PSGI->new( app => Shiori::Web->new );
my $app = $psgi->to_psgi_app;

builder {
    $app;
};
