#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

foreach my $path ( split( /:/, $ENV{ PATH } ) )
{
   print "[$path]\n";
}

<STDIN>;

exit 0;
