#!/usr/bin/perl

use strict;

my $target = $ARGV[0];

my $first = 0;

while(<STDIN>) {
    my @f = split(/,/);
    if ( $first == 0 ) {
	$first = $f[0];
    }
    if ( $first <= $target && $f[0] >= $target ) {
	print;
	exit;
    }
}
