use strict;
use warnings;
use WebService::Hatena::Bookmark;
use WebService::Hatena::Bookmark::Util;
use Config::Pit;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

GetOptions(\my %opts, qw(from=s to=s)) or die;

my $conf = Config::Pit::get('www.hatena.ne.jp', require => {
    user => 'hatena id',
    pass => 'password',
});

my $hb = WebService::Hatena::Bookmark->new( %$conf );

my $feed = $hb->feed( tags => [$opts{from}] );
foreach my $entry ( $feed->entries ) {
    my $orig_tags = tags_from_entry($entry->as_xml);

    my $converted_tags   = [ grep { $_ ne $opts{from} } @$orig_tags ];
    push @$converted_tags, $opts{to};

    $hb->edit( link => edituri($entry), tags => $converted_tags );
}

sub edituri {
    my $entry = shift;

    my @link = grep { $_->rel eq 'service.edit' } $entry->link;
    $link[0]->href;
}
