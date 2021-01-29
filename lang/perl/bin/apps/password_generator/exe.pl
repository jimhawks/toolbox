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
use lib "$FindBin::RealBin/../../../lib";
use My::Objects::Exe;
use My::Objects::Password_Generator;
use My::Constants qw(
   $TRUE
   $FALSE
   $YES
   $NO
);
use My::Utils qw(
   is_array_empty
   is_empty
   is_non_empty
   nvl
   substitute_shell_vars_in_array
   substitute_shell_vars_in_str
   trim
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
   letters|l
   symbols|s
   numbers|n
   lowercase|lc
   uppercase|uc

   no_write_history|nwh
   dash_group|dg

   num_passwords|np=i
   data_dir|dd=s

   prompt|pr
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
   @ARGV = substitute_shell_vars_in_array( @ARGV );

   # save argv in case prompt opt was given
   my @save_ARGV = @ARGV;

   # create exe obj which gets options and args
   $exe = new My::Objects::Exe( arg_list => \@arg_list, opt_spec => \@opt_spec );
   
   # if prompt option, then prompt for cmd line args
   if ( is_non_empty( get_prompt_opt() ) and get_prompt_opt() == $TRUE )
   {
      print "enter cmd line args (enter to accept defaults): ";
      chomp( my $str = <STDIN> );
      $str = trim( $str );
      $str =~ s/  */ /g;
      #$str =~ s/\$(\w+)/$ENV{$1}/g;
      $str = substitute_shell_vars_in_str( $str );
      my @tmp = split( / /, $str );
      @ARGV = ( @save_ARGV, @tmp );
      $exe = new My::Objects::Exe( arg_list => \@arg_list, opt_spec => \@opt_spec );
   }

   # get options
   my $use_letters   = get_letters_opt();
   my $use_numbers   = get_numbers_opt();
   my $use_symbols   = get_symbols_opt();
   my $use_uppercase = get_uppercase_opt();
   my $use_lowercase = get_lowercase_opt();

   my $write_history = nvl( get_no_write_history_opt(), $FALSE ) == $FALSE ? $YES : $NO;

   # if no char options specified, set all to true
   if ( is_empty( $use_letters ) 
        and is_empty( $use_numbers ) 
        and is_empty( $use_symbols ) 
        and is_empty( $use_uppercase ) 
        and is_empty( $use_lowercase ) )
   {
      $use_letters   = $TRUE;
      $use_numbers   = $TRUE;
      $use_symbols   = $TRUE;
      $use_uppercase = $TRUE;
      $use_lowercase = $TRUE;
   }

   # default unset char options to false
   $use_letters   = nvl( $use_letters,   $FALSE );
   $use_numbers   = nvl( $use_numbers,   $FALSE );
   $use_symbols   = nvl( $use_symbols,   $FALSE );
   $use_lowercase = nvl( $use_lowercase, $FALSE );
   $use_uppercase = nvl( $use_uppercase, $FALSE );

   if ( $use_lowercase == $TRUE or $use_uppercase == $TRUE )
   {
      $use_letters = $TRUE;
   }
   elsif ( $use_letters == $TRUE and $use_lowercase == $FALSE and $use_uppercase == $FALSE )
   {
      $use_lowercase = $TRUE;
      $use_uppercase = $TRUE;
   }

   # convert t/f to y/n
   $use_letters   = ( $use_letters   == $TRUE ) ? $YES : $NO;
   $use_numbers   = ( $use_numbers   == $TRUE ) ? $YES : $NO;
   $use_symbols   = ( $use_symbols   == $TRUE ) ? $YES : $NO;
   $use_lowercase = ( $use_lowercase == $TRUE ) ? $YES : $NO;
   $use_uppercase = ( $use_uppercase == $TRUE ) ? $YES : $NO;

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
   <STDIN>;
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
   return( $exe->get_opt_value( "dash_group" ) );
}

sub get_data_dir_opt
{
   return( $exe->get_opt_value( "data_dir" ) );
}

sub get_letters_opt
{
   return( $exe->get_opt_value( "letters" ) );
}

sub get_lowercase_opt
{
   return( $exe->get_opt_value( "lowercase" ) );
}

sub get_no_write_history_opt
{
   return( $exe->get_opt_value( "no_write_history" ) );
}

sub get_num_passwords_opt
{
   return( $exe->get_opt_value( "num_passwords" ) );
}

sub get_numbers_opt
{
   return( $exe->get_opt_value( "numbers" ) );
}

sub get_prompt_opt
{
   return( $exe->get_opt_value( "prompt" ) );
}

sub get_symbols_opt
{
   return( $exe->get_opt_value( "symbols" ) );
}

sub get_uppercase_opt
{
   return( $exe->get_opt_value( "uppercase" ) );
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

