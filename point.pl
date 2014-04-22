#!/usr/local/env perl
use strict;
use warnings;
use Point;
use Data::Dumper;

my $p = Point->new(10, 20);
print "===========\nPoint Object\n===========\n";
print Dumper $p;

print "===========\nGet\n===========\n";
printf "x = %d\n", $p->x();
printf "y = %d\n", $p->y();

print "===========\nIf 'private' or 'checksum' is changed ... \n===========\n";
$p->{checksum} = "abcde";
print Dumper $p;
print "-----\n access failed!! \n-----\n";
print "x = " . $p->x() ."\n";
