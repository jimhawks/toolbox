#!/usr/bin/perl

use strict;
use warnings;

my $str = " 1   3 ";

$str =~ s/  */ /g;

print "[$str]\n";

