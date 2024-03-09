#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;

use File::Basename qw(basename);
use File::Copy qw(move);
use JSON;

use Data::Dumper;

# constants
my $SCRIPT_NM = basename( $0 );

#--------------------------------------------------------
#
# main
#
#--------------------------------------------------------
