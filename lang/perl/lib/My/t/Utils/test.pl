#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;
use Data::Dumper;

@ARGV=( "v1", "v2" );

print Dumper( \@ARGV );

exit 0;
