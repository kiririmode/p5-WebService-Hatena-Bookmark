use warnings;
use strict;
use Test::More;
use Test::Flatten;
use WebService::Hatena::Bookmark;
use utf8;

my $hb = WebService::Hatena::Bookmark->new('user', 'pass');

subtest 'make_summary' => sub {
    is $hb->make_summary(tags => ['test', 'test2'], comment => 'Test' ), '[test][test2]Test', 'created summary';
    is $hb->make_summary(comment => 'Test' ), 'Test',       'without tags';
    is $hb->make_summary(tags => [qw/a b c/]), '[a][b][c]', 'without comment';
};

subtest 'make_feed_query' => sub {
    is $hb->make_feed_query( tags => ['aaa'] ),   'tag=aaa',     'with one tag';
    is $hb->make_feed_query( tags => [qw/a b/] ), 'tag=a&tag=b', 'with two tags';

    is $hb->make_feed_query( date => '20130713' ), 'date=20130713', 'with date' ;
    is $hb->make_feed_query( tags => ['aaa'], date => '20130111'), 'tag=aaa&date=20130111', 'with date and one tag';

};

done_testing;
