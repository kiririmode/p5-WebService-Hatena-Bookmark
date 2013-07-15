use warnings;
use strict;
use Test::More;
use Test::Flatten;
use XML::Atom::Feed;
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

subtest 'paging' => sub {
    my $paging = <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://purl.org/atom/ns#" xml:lang="ja">
  <link rel="next" type="application/x.atom+xml" href="http://b.hatena.ne.jp/hoge/atomfeed?of=40"/>
  <link rel="prev" type="application/x.atom+xml" href="http://b.hatena.ne.jp/hoge/atomfeed?of=0"/>
</feed>
XML
    my $paging_atom = XML::Atom::Feed->new( \$paging );

    my $next = <<'XML2';
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://purl.org/atom/ns#" xml:lang="ja">
  <link rel="next" type="application/x.atom+xml" href="http://b.hatena.ne.jp/hoge/atomfeed?of=20"/>
</feed>
XML2
    my $next_atom = XML::Atom::Feed->new( \$next );

    my $prev = <<'XML3';
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://purl.org/atom/ns#" xml:lang="ja">
  <link rel="prev" type="application/x.atom+xml" href="http://b.hatena.ne.jp/hoge/atomfeed?of=20"/>
</feed>
XML3
    my $prev_atom = XML::Atom::Feed->new( \$prev );

    ok(     has_prev($paging_atom), 'have prev');
    ok(     has_next($paging_atom), 'have next');

    ok((not has_prev($next_atom)),  'not have prev');
    ok(     has_next($next_atom),   'have next');

    ok(     has_prev($prev_atom),   'have prev');
    ok((not has_next($prev_atom)),  'have next');
};

done_testing;
