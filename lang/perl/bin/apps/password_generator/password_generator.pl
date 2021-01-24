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
use lib "$FindBin::Bin/../../../lib";
use My::Objects::Exe;
use My::Objects::Password_Generator;
use My::Constants qw(
   $TRUE
   $FALSE
   $YES
   $NO
);
use My::Utils qw(
   nvl
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
   no_letters|l
   no_symbols|s
   no_numbers|n
   no_lowercase|lc
   no_uppercase|uc
   no_write_history|wh

   dash_group|dg
   num_passwords|np=i
   data_dir|dd=s
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

   my $use_letters   = nvl( get_no_letters_opt(),   $FALSE ) == $FALSE ? $YES : $NO;
   my $use_numbers   = nvl( get_no_numbers_opt(),   $FALSE ) == $FALSE ? $YES : $NO;
   my $use_symbols   = nvl( get_no_symbols_opt(),   $FALSE ) == $FALSE ? $YES : $NO;
   my $use_uppercase = nvl( get_no_uppercase_opt(), $FALSE ) == $FALSE ? $YES : $NO;
   my $use_lowercase = nvl( get_no_lowercase_opt(), $FALSE ) == $FALSE ? $YES : $NO;

   my $write_history = nvl( get_no_write_history_opt(), $FALSE ) == $FALSE ? $YES : $NO;

   $pgen = new My::Objects::Password_Generator(
              letters       => $use_letters,
              numbers       => $use_numbers,
              symbols       => $use_symbols,
              uppercase     => $use_uppercase,
              lowercase     => $use_lowercase,
              write_history => $write_history,

              data_dir      => get_data_dir_opt(),
           );
}

sub main
{
   my $num_passwords = nvl( get_num_passwords_opt(), 1 );

   my @passwords = ();
   if ( nvl( get_dash_group_opt(), $FALSE ) == $TRUE )
   {
      my $num_groups = shift @ARGV;
      my $group_len  = shift @ARGV;
      @passwords = $pgen->get_dash_passwords( 
         num_groups    => $num_groups,
         group_len     => $group_len,
         num_passwords => $num_passwords,
      );
   }
   else
   {
      my $max_password_len = pop @ARGV;
      my $min_password_len = nvl( pop @ARGV, $max_password_len );

      @passwords = $pgen->get_passwords( 
         min_len       => $min_password_len,
         max_len       => $max_password_len,
         num_passwords => $num_passwords,
      );
   }

   print join( "\n", @passwords ) . "\n";
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

sub get_data_dir_opt
{
   return( $exe->get_opt_value( "data_dir" ) );
}

sub get_dash_group_opt
{
   return( $exe->get_opt_value( "dash_group" ) );
}

sub get_no_letters_opt
{
   return( $exe->get_opt_value( "no_letters" ) );
}

sub get_no_lowercase_opt
{
   return( $exe->get_opt_value( "no_lowercase" ) );
}

sub get_no_numbers_opt
{
   return( $exe->get_opt_value( "no_numbers" ) );
}

sub get_no_symbols_opt
{
   return( $exe->get_opt_value( "no_symbols" ) );
}

sub get_no_uppercase_opt
{
   return( $exe->get_opt_value( "no_uppercase" ) );
}

sub get_no_write_history_opt
{
   return( $exe->get_opt_value( "no_write_history" ) );
}

sub get_num_passwords_opt
{
   return( $exe->get_opt_value( "num_passwords" ) );
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

exit 0;

