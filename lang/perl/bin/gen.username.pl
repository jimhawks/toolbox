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
use lib "$FindBin::RealBin/../lib";
use My::Objects::Exe;
use My::Constants qw(
   $TRUE
   $FALSE
);
use My::Utils qw(
   get_random_username
   nem
);

#--------------------------------------------------
#
# globals
#
#--------------------------------------------------
my $exe = "";
my @arg_list = qw(
   num_items
);
my @opt_spec = qw(
   prompt|pr
);


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
   $exe = new My::Objects::Exe( 
             arg_list => \@arg_list, 
             opt_spec => \@opt_spec 
          );

   if ( nem( get_prompt_opt(), $FALSE ) == $TRUE )
   {
      print "Enter num items (default is 1): ";
      chomp( my $n = <STDIN> );
      set_num_items( nem( $n, 1 ) );
   }
   else 
   {
      set_num_items( nem( get_num_items_arg(), 1 ) );
   }
   get_num_items() > 0 or confess "ERROR. num items is 0 or negative.";
}

sub main
{
   foreach ( 1 .. get_num_items() )
   {
      print get_random_username() . "\n";
   }
}

sub term
{
   if ( nem( get_prompt_opt(), $FALSE ) == $TRUE )
   {
      <STDIN>;
   }
}
           

#--------------------------------------------------
#
# functions - others
#
#--------------------------------------------------


#--------------------------------------------------
#
# getters/setters - exe - options
#
#--------------------------------------------------
sub get_prompt_opt
{
   return( $exe->get_opt_value( "prompt" ) );
}


#--------------------------------------------------
#
# getters/setters - exe - args
#
#--------------------------------------------------
sub get_num_items_arg
{
   return( $exe->get_arg_value( "num_items" ) );
}


#--------------------------------------------------
#
# getters/setters - exe - data
#
#--------------------------------------------------
sub get_num_items
{
   return( $exe->get_data_value( "num_items" ) );
}

sub set_num_items
{
   $exe->set_data_value( "num_items", @_ );
}


exit 0;

