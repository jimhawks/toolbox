#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

foreach my $key ( sort keys %ENV )
{
   print "$key=[" . $ENV{ $key } . "]\n";
}

<STDIN>;

exit 0;
