#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

use FindBin;
use HTTP::Tiny;
use Path::Tiny;

sub get_latest_url {
    my $str = shift;
    my $line;
    for(split(/\n/ => $str)) {
        next unless/node-v([\d.]+).tar.gz/;
        $line = $_;
        last;
    }
    die "line not found in $str" unless $line;
    my @m = $line =~ /node-v(.*?).tar.gz/;
    my $version = "$m[0]";
    return $version;
}

my $cache_file = "$FindBin::Bin/.latest_node_version";

sub read_cache_file {
    if( -e "$cache_file" ) {
        my $contents = do {
            local $/;
            open( my $fh, "<", $cache_file ) or die "$@ $!";
            <$fh>;
        };
        return "$contents\n";
        return "";
    }
}

sub write_cache_file {
    my $contents = shift;

}
sub main {
    if( my $str = read_cache_file ) {
        print $str;
        return 0;
    }
    my $latest_url = 'http://nodejs.org/dist/latest/';
    my $ua = HTTP::Tiny->new;
    my $res = $ua->get( $latest_url );
    $latest_url = get_latest_url($res->{content});
    write_cache_file( $latest_url );
    print "$latest_url\n";
    return 0;
}
exit(main);
