#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';
use FindBin;
use IPC::System::Simple qw[ capture ];
use IO::All;

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
    my $version = "v$m[0]";
    return $version;

}
sub main {
    my $latest_url = 'http://nodejs.org/dist/latest/';
    my $cache_file = io->file("$FindBin::Bin/.latest_node_version");
    if( -e "$cache_file" ) {
        print "".$cache_file->slurp,"\n";
        return 0;
    }
    my $res = capture( 'curl', $latest_url );
    $latest_url = get_latest_url($res);
    $cache_file->print($latest_url);
    print "$latest_url\n";
    return 0;
}
exit(main);
