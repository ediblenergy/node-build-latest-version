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

sub main {
    my $latest_url = 'http://nodejs.org/dist/latest/';
    my $ua = HTTP::Tiny->new;
    my $cache_file = path("$FindBin::Bin/.latest_node_version");
    if( -e "$cache_file" ) {
        print "".$cache_file->slurp,"\n";
        return 0;
    }
    my $res = $ua->get( $latest_url );
    $latest_url = get_latest_url($res->{content});
    $cache_file->spew($latest_url);
    print "$latest_url\n";
    return 0;
}
exit(main);
