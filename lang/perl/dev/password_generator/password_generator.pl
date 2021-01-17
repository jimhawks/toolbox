#!/usr/bin/perl -d

use strict;
use warnings;
use Data::Dumper;

#--------------------------------------------------
#
# modules - system
#
#--------------------------------------------------
use FindBin;

#--------------------------------------------------
#
# modules - custom
#
#--------------------------------------------------
use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Exe;
use My::Objects::Password_Generator;
use My::Constants qw(
   $YES
   $NO
);

#--------------------------------------------------
#
# globals
#
#--------------------------------------------------
my $exe = "";
my @arg_list = qw(
);
my @opt_spec = qw(
   letters|l=s
   symbols|s=s
   numbers|n=s
   lowercase|w=s
   uppercase|u=s
   dash_group|d=s
   num_passwords|p=i
);

my $pgen = "";


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
   $exe = new My::Objects::Exe( arg_list => \@arg_list, opt_spec => \@opt_spec );

   $pgen = new My::Objects::Password_Generator(
              letters    => get_letters_opt(),
              numbers    => get_numbers_opt(),
              symbols    => get_symbols_opt(),
              uppercase  => get_uppercase_opt(),
              lowercase  => get_lowercase_opt(),
           );
}

sub main
{
   
   
   if ( $exe->get_dash_group_opt() eq $YES )
   {
      $exe->set_num_groups( $exe->get_arg1_arg() );
      $exe->set_group_len(  $exe->get_arg2_arg() );
   }
   else
   {
      $exe->set_num_groups( $exe->get_arg1_arg() );
      $exe->set_group_len(  $exe->get_arg2_arg() );
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


#--------------------------------------------------
#
# getters/setters - exe - options
#
#--------------------------------------------------

sub get_dash_group_opt
{
   return( $exe->get_opt_value( "dash_group" );
}

sub get_letters_opt
{
   return( $exe->get_opt_value( "letters" );
}

sub get_lowercase_opt
{
   return( $exe->get_opt_value( "lowercase" );
}

sub get_numbers_opt
{
   return( $exe->get_opt_value( "numbers" );
}

sub get_symbols_opt
{
   return( $exe->get_opt_value( "symbols" );
}

sub get_uppercase_opt
{
   return( $exe->get_opt_value( "uppercase" );
}

sub get_num_passwords_opt
{
   return( $exe->get_opt_value( "num_passwords" );
}

#--------------------------------------------------
#
# getters/setters - exe - args
#
#--------------------------------------------------


#--------------------------------------------------
#
# getters/setters - exe - data
#
#--------------------------------------------------

sub get_group_len
{
   return( $exe->get_data_value( "group_len" );
}

sub set_group_len
{
   $exe->set_data_value( "group_len", @_ );
}

sub get_max_password_len
{
   return( $exe->get_data_value( "max_password_len" );
}

sub set_max_password_len
{
   $exe->set_data_value( "max_password_len", @_ );
}

sub get_min_password_len
{
   return( $exe->get_data_value( "min_password_len" );
}

sub set_min_password_len
{
   $exe->set_data_value( "min_password_len", @_ );
}

sub get_num_groups
{
   return( $exe->get_data_value( "num_groups" );
}

sub set_num_groups
{
   $exe->set_data_value( "num_groups", @_ );
}

exit 0;

