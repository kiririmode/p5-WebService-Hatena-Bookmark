use warnings;
use strict;
use Test::More;
use Test::Flatten;
use WebService::Hatena::Bookmark::Util;
use utf8;

subtest 'make_summary' => sub {
    is make_summary(tags => ['test', 'test2'], comment => 'Test' ), '[test][test2]Test', 'created summary';
    is make_summary(comment => 'Test' ), 'Test',       'without tags';
    is make_summary(tags => [qw/a b c/]), '[a][b][c]', 'without comment';
};

subtest 'make_feed_query' => sub {
    is make_feed_query( tags => ['aaa'] ),   'tag=aaa',     'with one tag';
    is make_feed_query( tags => [qw/a b/] ), 'tag=a&tag=b', 'with two tags';

    is make_feed_query( date => '20130713' ), 'date=20130713', 'with date' ;
    is make_feed_query( tags => ['aaa'], date => '20130111'), 'tag=aaa&date=20130111', 'with date and one tag';

};

subtest 'tags_from_entry' => sub {
    my $xml = <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<entry xmlns="http://purl.org/atom/ns#">
    <dc:subject xmlns:dc="http://purl.org/dc/elements/1.1/">test</dc:subject>
    <dc:subject xmlns:dc="http://purl.org/dc/elements/1.1/">test1</dc:subject>
  </entry>
XML

    is_deeply tags_from_entry($xml), [qw/test test1/], 'tags from entry';
};

done_testing;
