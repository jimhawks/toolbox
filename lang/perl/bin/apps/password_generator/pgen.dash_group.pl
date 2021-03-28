#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;

#--------------------------------------------------
#
# modules - system
#
#--------------------------------------------------
use Carp qw( cluck confess );
use File::Basename;

#--------------------------------------------------
#
# modules - custom
#
#--------------------------------------------------
use FindBin;
use lib "$FindBin::RealBin"
        . "/" . ( ( -e "$FindBin::RealBin/exe.pl" ) ?  "../../../lib" : "../lib" );

use My::Utils qw(
   nvl
);



#--------------------------------------------------
#
# main
#
#--------------------------------------------------
my $exe = (-e "$FindBin::RealBin/exe.pl" ) ? "exe.pl" : "password_generator.pl";
my $cmd = "$FindBin::RealBin/$exe"
          . " -dg"
          . " " . join( " ", @ARGV )
          ;
my @output = `$cmd`;
print @output;

exit 0;





