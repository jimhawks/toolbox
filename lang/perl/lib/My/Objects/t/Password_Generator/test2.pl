#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;

use FindBin;


my $str = "debug|d=s";
my $str2 = "status|s:s";

foreach my $spec ( $str, $str2 )
{
   print "spec=[$spec]\n";
   my ( $name, $other ) = split( /[:=]/, $spec );
   print "name=[$name]\n";
   my ( $lname, $sname ) = split( /\|/, $name );
   print "lname=[$lname]\n";
   print "sname=[$sname]\n";
}



exit 0;

