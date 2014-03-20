package Shiori::Web::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;
    my $page = $self->param('page') || 1;
    my ($entries, $pager) = $self->model->entries({ page => $page, limit => 10 });
    $self->stash->{entries} = $entries;
    $self->stash->{pager} = $pager;
    $self->render();
}

sub post {
    my $self = shift;
    $self->stash->{messages} = undef;
    $self->render();
}

sub create {
    my $self = shift;
    my $validation = $self->validation();
    if( $validation->csrf_protect->has_error() ){
        return $self->render_not_found();
    }
    my $res = $self->model->create({ url => $self->param('url') });
    if( $res->{error} ) {
        $self->stash->{messages} = $res->{error}{messages};
        return $self->render('root/new');
    }
    $self->redirect_to('/');
}

1;
