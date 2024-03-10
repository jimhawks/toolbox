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
use FindBin;

#--------------------------------------------------
#
# modules - custom
#
#--------------------------------------------------
use lib "$FindBin::RealBin/../../../../lib";
use My::Constants qw(
   $TRUE
   $FALSE
);
use My::Utils qw(
   is_str_non_empty
   nem
);

#--------------------------------------------------
#
# globals
#
#--------------------------------------------------

my %funcs = ();
my %written_tests = ();

my %all_items = ();
my %funcs_wo_tests = ();
my %tests_wo_funcs = ();

###################################################
#
# process
#
###################################################
init();
main();
term();

exit 0;


#--------------------------------------------------
#
# functions - top level
#
#--------------------------------------------------
sub init
{
   # get list of funcs for module
   foreach my $func ( sort @My::Utils::EXPORT ) 
   {
      $funcs{ $func }     = 1;
      $all_items{ $func } = 1;
   }

   # get list of written tests
   foreach my $test ( glob '*.t' )
   {
      $test =~ s/\.t$//;
      $written_tests{ $test } = 1;
      $all_items{ $test }     = 1;
   }
   
}

sub main
{
   print "status\n";
   foreach my $item ( sort keys %all_items )
   {
      my $f = "-";  #function flag
      if ( $funcs{ $item } )
      {
         $f = "f";
      }

      my $t = "-";
      if ( $written_tests{ $item } )
      {
         $t = "t";
      }

      if ( $f eq "-" )
      {
         $tests_wo_funcs{ $item } = 1;
      }
      elsif ( $t eq "-" )
      {
         $funcs_wo_tests{ $item } = 1;
      }

      print "$f $t $item\n";

   }

   print "\n";
   print "funcs w/o tests\n";
   foreach my $func ( sort keys %funcs_wo_tests )
   {
      print "$func\n";
   }

   print "\n";
   print "tests w/o funcs\n";
   foreach my $test ( sort keys %tests_wo_funcs )
   {
      print "$test.t\n";
   }
}

sub term
{
}
           

#--------------------------------------------------
#
# functions - others
#
#--------------------------------------------------




