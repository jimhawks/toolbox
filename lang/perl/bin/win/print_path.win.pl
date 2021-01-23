#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @paths = split( /;/, $ENV{ PATH } );
foreach my $path ( @paths )
{
   print "[$path]\n";
}

<STDIN>;

exit 0;
