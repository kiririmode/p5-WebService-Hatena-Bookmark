package WebService::Hatena::Bookmark::Util;
use 5.008005;
use strict;
use warnings;

use Exporter 'import';
our @EXPORT = qw/make_summary make_feed_query/;

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

    join '&', @query;
}

1;
