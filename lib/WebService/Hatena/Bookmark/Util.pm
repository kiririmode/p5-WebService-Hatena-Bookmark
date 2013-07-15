package WebService::Hatena::Bookmark::Util;
use 5.008005;
use strict;
use warnings;

use XML::XPath;

use Exporter 'import';
our @EXPORT = qw/make_summary make_feed_query tags_from_entry has_prev has_next/;

sub make_summary {
    my (%args) = @_;

    my $tags = delete $args{tags} || [];
    my @tags    = @{ $tags };
    my $tag_str = @tags?          join('', map "[$_]", @tags) : '';

    my $comment = $args{comment}? $args{comment}              : '';

    my $summary = $tag_str . $comment;
}

sub make_feed_query {
    my (%args) = @_;

    my @query;

    if ( $args{tags} ) {
        my $tags = delete $args{tags};
        push @query, "tag=$_" for @$tags;
    }
    if ( $args{date} ) {
        push @query, "date=$args{date}"
    }
    if ( $args{offset} ) {
        push @query, "of=$args{offset}"
    }

    join '&', @query;
}

sub tags_from_entry {
    my ($xml) = @_;

    my @tags;

    my $xp = XML::XPath->new( xml => $xml );
    push(@tags, $_->string_value) for $xp->findnodes('//dc:subject');

    \@tags;
}

sub has_prev {
    _has_paging($_[0], 'prev');
}

sub has_next {
    _has_paging($_[0], 'next');
}

sub _has_paging {
    my ($feed, $direction) = @_;

    grep { $_->rel eq $direction } $feed->link;
}

1;
