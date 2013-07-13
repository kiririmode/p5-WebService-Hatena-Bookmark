package WebService::Hatena::Bookmark;
use 5.008005;
use strict;
use warnings;

use XML::Atom::Client;
use XML::Atom::Entry;
use Encode;
use Carp;
use constant POST_URI => 'http://b.hatena.ne.jp/atom/post';
use constant FEED_URI => 'http://b.hatena.ne.jp/atom/feed';
use constant EDIT_URI => 'http://b.hatena.ne.jp/atom/edit';

our $VERSION = "0.01";


# TODO: OAuth 認証対応

sub new {
    my ($class, %opts) = @_;

    my $user = delete $opts{user};
    my $pass = delete $opts{pass};

    my $client = XML::Atom::Client->new;
       $client->username($user);
       $client->password($pass);

    bless {
        client => $client,
    }, $class;
}

sub add {
    my ($self, %args) = @_;

    my $entry = XML::Atom::Entry->new;
    
    my $link = XML::Atom::Link->new;
    $link->rel('related');
    $link->type('text/html');
    $link->href($args{link});
    $entry->add_link($link);

    my $summary = $self->make_summary( tags => $args{tags}, comment => $args{comment} );
    $entry->summary( encode('utf-8' => $summary ) );

    my $loc = $self->{client}->createEntry(POST_URI, $entry)
        or croak $self->{client}->errstr;
}

sub refer {
    my ($self, %args) = @_;

    my $url = $args{link};
    $self->{client}->getEntry($url) or croak $self->{client}->errstr;
}

sub edit {
    my ($self, %args) = @_;

    my $link    = delete $args{link};
    my $title   = delete $args{title};
    my $tags    = delete $args{tags};
    my $comment = delete $args{comment};
    
    my $summary = $self->make_summary( tags => $tags, comment => $comment );

    my $entry = XML::Atom::Entry->new;
    $entry->title(   encode('utf-8' => $title) )    if $title;
    $entry->summary( encode('utf-8' => $summary ) ) if $summary;

    $self->{client}->updateEntry( $link, $entry ) or croak $self->{client}->errstr;
}

sub delete {
    my ($self, %args) = @_;

    my $link = delete $args{link};
    $self->{client}->deleteEntry( $link ) or croak $self->{client}->errstr;
}

sub feed {
    my ($self, %args) = @_;

    my $query = $self->make_feed_query( %args );
    $self->{client}->getFeed( FEED_URI . '?' . $query ) or croak $self->{client}->errstr;
}

sub make_summary {
    my ($self, %args ) = @_;

    my $tags = delete $args{tags} || [];
    my @tags    = @{ $tags };
    my $tag_str = @tags?          join('', map "[$_]", @tags) : '';

    my $comment = $args{comment}? $args{comment}              : '';

    my $summary = $tag_str . $comment;
}

sub make_feed_query {
    my ($self, %args) = @_;

    my @query;

    if ( $args{tags} ) {
        my $tags = delete $args{tags};
        push @query, "tag=$_" for @$tags;
    }
    if ( $args{date} ) {
        push @query, "date=$args{date}"
    }

    join '&', @query;
}

1;
__END__

=encoding utf-8

=head1 NAME

WebService::Hatena::Bookmark - It's new $module

=head1 SYNOPSIS

    use WebService::Hatena::Bookmark;

=head1 DESCRIPTION

WebService::Hatena::Bookmark is ...

=head1 LICENSE

Copyright (C) kiririmode.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kiririmode E<lt>kiririmode@gmail.comE<gt>

=cut

