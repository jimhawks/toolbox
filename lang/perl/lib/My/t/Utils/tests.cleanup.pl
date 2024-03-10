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
use File::Copy qw( copy );
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

my $test_template_file = "test.t.tmpl";

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
   # determine status
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
   }

   print "\n";
   print "adding missing tests\n";
   foreach my $func ( sort keys %funcs_wo_tests )
   {

      my $test_file = "$func.t";
      copy( $test_template_file, $test_file )
         or die "Copy test template failed.  tmpl=[$test_template_file] file=[$test_file]";
      chmod( 0775, $test_file ) or die "Chmod failed.  file=[$test_file]";
      print "$test_file\n";
   }

   print "\n";
   print "removing unused tests\n";
   foreach my $test ( sort keys %tests_wo_funcs )
   {
      my $test_file = "$test.t";
      print "$test_file\n";
      unlink $test_file or die "Delete failed. file=[$test_file]";
   }

   print "\n";
}

sub term
{
}
           

#--------------------------------------------------
#
# functions - others
#
#--------------------------------------------------




