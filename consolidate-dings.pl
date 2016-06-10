#!/usr/bin/perl

use strict;

my $before = 5;
my $after = 5;

my $consolidate = 10;

my $start = 0;
my $end = 0;
my $duration = 0;

sub doit {
    my ( $start, $end ) = @_;

    $start = int($start);
    $end = int($end);

    my $duration = $end - $start;

    print "$start\t$duration\n";
}

while(<STDIN>) {
    chomp;
    my $ding = $_;

    $start = $ding - $before if ( $start == 0 );

    if ( $ding > $start + $consolidate ) {
	doit($start, $end);
	$start = $ding - $before;
	$end = $ding + $after;	
    }
    else {
	$end = $ding + $after;
    }
}

if ( $start != 0 ) {
    $end = $start + $before + $after;
    doit($start, $end);
}

