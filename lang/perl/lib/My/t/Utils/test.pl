#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   read_file
);

my $SCRIPT = basename( $0 );

myf1();


exit 0;

sub myf1
{
   read_file("bogusfile");
}

