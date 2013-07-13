use strict;
use Test::More;
use WebService::Hatena::Bookmark;

my $hb = WebService::Hatena::Bookmark->new('user', 'pass');
isa_ok( $hb, 'WebService::Hatena::Bookmark' );

done_testing;
