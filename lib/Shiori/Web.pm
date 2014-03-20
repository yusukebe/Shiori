package Shiori::Web;
use Mojo::Base 'Mojolicious';
use Shiori::Model::Bookmark;

sub startup {
    my $self = shift;

    my $model = Shiori::Model::Bookmark->new();
    $self->helper(
        model => sub {
            return $model;
        }
    );

    my $r = $self->routes;
    $r->namespaces([qw/Shiori::Web::Controller/]);
    $r->get('/')->to('root#index');
    $r->get('/new')->to('root#post');
    $r->post('/create')->to('root#create');
}

1;
