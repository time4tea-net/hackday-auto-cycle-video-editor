#!/usr/bin/perl

use strict;
use Text::CSV;
use List::MoreUtils qw(natatime);

my $csv = Text::CSV->new();

sub semi_to_deg {
    my ($semi) = @_;

    return $semi * ( 180.0 / 2**31 );
}

sub handle_record {
    my ($r) = @_;

    my $ts = $r->{timestamp} + 631065600;
    my $lat = semi_to_deg($r->{position_lat});
    my $lon = semi_to_deg($r->{position_long});

    print "$ts,$lat,$lon\n";
}

while(<STDIN>) {
    chomp;
    next unless /^Data/;
    
    if ($csv->parse($_)) {
	my @fields = $csv->fields();

	if ( $fields[2] eq 'record' ) {
	    my @records = @fields[3 .. $#fields];
	    my $it = natatime(3, @records);
	    
	    my %map = {};

	    while(my @record = $it->()) {
		my ($type, $value, $unit) = @record;
		$map{$type} = $value;
	    }

	    handle_record(\%map);
	}
    }
}
