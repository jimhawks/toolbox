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
use FindBin;

#--------------------------------------------------
#
# modules - custom
#
#--------------------------------------------------
use lib "$FindBin::RealBin/../../../lib";
use My::Utils qw(
   nvl
);



#--------------------------------------------------
#
# main
#
#--------------------------------------------------
my $cmd = "$FindBin::RealBin/exe.pl"
          . " -n"
          . " " . join( " ", @ARGV )
          ;
my @output = `$cmd`;
print @output;

exit 0;





