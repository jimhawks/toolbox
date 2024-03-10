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
use My::Objects::Password_Generator;
use My::Constants qw(
);
#   $TRUE
#   $FALSE
#   $YES
#   $NO
use My::Utils qw(
   is_str_non_empty
   substitute_shell_vars_in_array
);
#   is_array_empty
#   is_str_empty
#   nvl
#   nvle
#   substitute_shell_vars_in_str
#   trim

#--------------------------------------------------
#
# globals
#
#--------------------------------------------------
my $exe = "";
my @arg_list = qw(
   dir
);
my @opt_spec = qw(
   case-insensitive|i
   file-pattern|fp=s@
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
   # create exe obj which gets options and args
   @ARGV = substitute_shell_vars_in_array( @ARGV );
   $exe = new My::Objects::Exe( arg_list => \@arg_list, opt_spec => \@opt_spec );
   
   # get search values
   set_search_dir( get_dir_arg() );
   set_search_strings( @ARGV );

   # validate values
   is_str_non_empty( get_search_dir() )     or confess "ERROR. search dir is empty";
   is_str_non_empty( get_search_strings() ) or confess "ERROR. search strings are empty";
}

sub main
{
#   my $num_passwords = nvl( get_num_passwords_opt(), 1 );
#
#   my @passwords = ();
#   if ( nvl( get_dash_group_opt(), $FALSE ) == $TRUE )
#   {
#      my $num_groups = shift @ARGV;
#      my $group_len  = shift @ARGV;
#      @passwords = $pgen->get_dash_passwords( 
#         num_groups    => $num_groups,
#         group_len     => $group_len,
#         num_passwords => $num_passwords,
#      );
#   }
#   else
#   {
#      my $max_password_len = pop @ARGV;
#      my $min_password_len = nvl( pop @ARGV, $max_password_len );
#
#      @passwords = $pgen->get_passwords( 
#         min_len       => $min_password_len,
#         max_len       => $max_password_len,
#         num_passwords => $num_passwords,
#      );
#   }
#
#   print join( "\n", @passwords ) . "\n";
}

sub term
{
   print Dumper( $exe );

#   if ( nvl( get_prompt_opt(), $FALSE ) == $TRUE )
#   {
#      <STDIN>;
#   }
}
           
##--------------------------------------------------
##
## functions - others
##
##--------------------------------------------------
#
#
#
##--------------------------------------------------
##
## getters/setters - exe - options
##
##--------------------------------------------------
#
#sub get_dash_group_opt
#{
#   return( $exe->get_opt_value( "dash_group" ) );
#}
#
#sub get_data_dir_opt
#{
#   return( $exe->get_opt_value( "data_dir" ) );
#}
#
#sub get_letters_opt
#{
#   return( $exe->get_opt_value( "letters" ) );
#}
#
#sub get_lowercase_opt
#{
#   return( $exe->get_opt_value( "lowercase" ) );
#}
#
#sub get_no_write_history_opt
#{
#   return( $exe->get_opt_value( "no_write_history" ) );
#}
#
#sub get_num_passwords_opt
#{
#   return( $exe->get_opt_value( "num_passwords" ) );
#}
#
#sub get_numbers_opt
#{
#   return( $exe->get_opt_value( "numbers" ) );
#}
#
#sub get_prompt_opt
#{
#   return( $exe->get_opt_value( "prompt" ) );
#}
#
#sub get_symbols_opt
#{
#   return( $exe->get_opt_value( "symbols" ) );
#}
#
#sub get_uppercase_opt
#{
#   return( $exe->get_opt_value( "uppercase" ) );
#}

#--------------------------------------------------
#
# getters/setters - exe - args
#
#--------------------------------------------------
sub get_dir_arg
{
   return( $exe->get_arg_value( "dir" ) );
}



#--------------------------------------------------
#
# getters/setters - exe - data
#
#--------------------------------------------------

sub get_search_dir
{
   return( $exe->get_data_value( "search_dir" ) );
}

sub set_search_dir
{
   $exe->set_data_value( "search_dir", @_ );
}

sub get_search_strings
{
   return( @{ $exe->get_data_array( "search_strings" )  } );
}

sub set_search_strings
{
   $exe->set_data_array( "search_strings", @_ );
}


