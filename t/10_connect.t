use strict;
use Test::More;
use Test::Flatten;
use Test::Exception;
use WebService::Hatena::Bookmark;
use Term::ReadLine;
use utf8;
use Encode;

plan skip_all => <<CONNECT_TEST unless $ENV{HATENA_CONNECT_TEST};
If you want to execute this code, define HATENA_CONNECT_TEST=1.
This test requires your hatena id and password interactively. 
CONNECT_TEST

my $term = Term::ReadLine->new('account');

my $user = $term->readline('hatena id   > ');
my $pass = $term->readline('hatena pass > ' );

my $hb = WebService::Hatena::Bookmark->new( user => $user, pass => $pass );

my $loc;
subtest "add a bookmark" => sub {

    ok $loc = $hb->add( 
        link    => 'http://www.google.co.jp', 
        tags    => ['test', 'test2' ], 
        comment => 'テストコメ' 
       ),
      'add a bookmark';
};

subtest "edit a bookmark" => sub {
    ok $hb->edit( 
        link    => $loc, 
        title   => 'Google Bookmark', 
        tags    => ['test', 'test3'], 
        comment => 'テスト' ),
       'edit a bookmark';
};

subtest "refer a bookmark" => sub {
    my $entry = $hb->refer( link => $loc );
    is $entry->author->name, $user, 'author';

    my $dc = XML::Atom::Namespace->new(dc => 'http://purl.org/atom/ns#');
    my $summary = $entry->get($dc, 'summary');
    is decode('utf-8', $summary), '[test][test3]テスト', 'summary';

    ok $hb->feed( tags => [qw/test3 test/] );
};

subtest "get editURI" => sub {
    my $edituri = $hb->edituri( url => 'http://www.google.co.jp/' );
    like $edituri, qr[http://b.hatena.ne.jp/atom/edit/\d+], 'get editURI';
};

subtest "delete a bookmark" => sub {
    ok $hb->delete( link => $loc ), 'delete a bookmark';
    throws_ok { $hb->refer( link => $loc ) } qr/404/, 'then 404 not found returned'
};

done_testing;
