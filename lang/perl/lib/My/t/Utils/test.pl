#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;

use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../../../lib";
use Encode;
use My::Utils qw(
   grepv_strs_in_array
);
use My::Constants qw(
   $TRUE
   $FALSE
);

my @lines = (
   "1 With less than 24 hours vix to go until one of the most closely watch",
   "2 Fed announcements in a long time, the VIX finds itself hanging just",
   "3 below 20, the gamma gravity in the S&P is at 4,000 while dealers remains",
   "4 short Nasdaq/QQQ gamma Vix (which however is shrinking by the day).",
);

my @list = grepv_strs_in_array(
   strs  => [ "24", "Gamma" ],
   array => \@lines,
   ignore_case => 1,
);
print Dumper( \@list );

exit 0;


