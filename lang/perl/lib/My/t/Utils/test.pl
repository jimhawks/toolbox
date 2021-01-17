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
use My::Constants qw(
   $TRUE
   $FALSE
);


print "result=[" . is_true( "true" ) . "]\n";
print "result=[" . is_true( "false" ) . "]\n";
print "result=[" . is_true( 1 ) . "]\n";
print "result=[" . is_true( 0 ) . "]\n";


sub is_true 
{
    my $val = shift;
    defined( $val ) or return 0;

    if ( $val eq "true" or $val == 1 )
    {
       return( 1 );
    }
    else 
    {
       return( 0 );
    }
}


exit 0;


