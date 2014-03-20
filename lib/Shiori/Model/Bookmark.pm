package Shiori::Model::Bookmark;
use Mouse;
use Shiori;
use Shiori::DB;
use DateTime;
use FormValidator::Lite;

FormValidator::Lite->load_constraints(qw/URL/);

has 'connect_info' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        return Shiori->config->{connect_info};
    }
);
has 'db' => ( is => 'ro', isa => 'Shiori::DB', lazy_build => 1 );

sub _build_db {
    my $self = shift;
    Shiori::DB->new(
        connect_info => $self->connect_info()
    );
}

sub create {
    my ($self, $args) = @_;
    my $validator = FormValidator::Lite->new($args);
    $validator->load_function_message('en');
    $validator->set_param_message( url => 'URL' );
    my $res = $validator->check(
        url => [qw/NOT_NULL HTTP_URL/],
    );
    if($validator->has_error) {
        my $messages = $validator->get_error_messages();
        return { error => { messages => $messages } };
    }
    my $now = $self->now;
    my $bookmark = $self->db->insert('bookmark', {
        url => $args->{url},
        created_at => $now,
        updated_at => $now
    });
    return { success => { bookmark => $bookmark } };
}

sub entries {
    my ($self, $args) = @_;
    my $limit = $args->{limit} || 10;
    my $page = $args->{page} || 1;
    my ( $entries, $pager ) = $self->db->search_with_pager( 'bookmark', {},
        { 
            page => $page,
            rows => $limit,
            order_by => 'id DESC'
        }
    );
    if(wantarray) {
        return ($entries, $pager);
    }else{
        return $entries;
    }
}

sub now {
    DateTime->now( time_zone => 'Asia/Tokyo' );
}

__PACKAGE__->meta->make_immutable();
