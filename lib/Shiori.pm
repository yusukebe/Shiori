package Shiori;
use strict;
use warnings;
use Config::PL;

our $VERSION = '0.01';
my $config;

sub _load_config {
    my $mode = $ENV{PLACK_ENV} || 'development';
    my $filename = "config_${mode}.pl";
    return config_do $filename;
}

sub config {
    return $config if $config;
    $config = Shiori->_load_config();
    return $config;
}

1;
