#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   get_random_birthdate
);
use My::Constants qw(
   $TRUE
   $FALSE
);

foreach my $cnt ( 1 .. 10 )
{
   print get_random_birthdate() . "\n";
}

exit 0;


