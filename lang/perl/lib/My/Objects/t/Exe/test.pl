#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use FindBin;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Exe;

my @optSpec = qw( 
   "abc" 
);
my @argList = qw(
   arg1
   arg2
);

my $obj = new My::Objects::Exe( optSpec => \@optSpec, argList => \@argList );
#my $obj = new My::Objects::Exe( );

print Dumper( $obj );


exit 0;
