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
   nvl
   nvle
   read_file
   remove_blank_lines
   remove_comment_lines
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
   book_title_file
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
   @ARGV = substitute_shell_vars_in_array( @ARGV );

   # save argv in case prompt opt was given
   my @save_ARGV = @ARGV;

   # create exe obj which gets options and args
   $exe = new My::Objects::Exe( arg_list => \@arg_list, opt_spec => \@opt_spec );

   # if prompt option, then prompt for cmd line args
   if ( nvl( get_prompt_opt(), $FALSE ) == $TRUE )
   {
      print "enter book title file (book_titles.txt): ";
      chomp( my $str = <STDIN> );
      $str = trim( $str );
      $str =~ s/  */ /g;
      #$str =~ s/\$(\w+)/$ENV{$1}/g;
      $str = substitute_shell_vars_in_str( $str );
      my @tmp = split( / /, $str );
      @ARGV = ( @save_ARGV, @tmp );
      $exe = new My::Objects::Exe( arg_list => \@arg_list, opt_spec => \@opt_spec );
   }
   
}

sub main
{
   chomp( my @titles = read_file( nvle( get_book_title_file_arg(), "./book_titles.txt" ) ) );
   @titles = remove_comment_lines( remove_blank_lines( @titles ) );
   foreach my $title ( @titles )
   {
      mkdir $title or print "ERROR. could not create dir. dir=[$title]";
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

sub get_prompt_opt
{
   return( $exe->get_opt_value( "prompt" ) );
}


#--------------------------------------------------
#
# getters/setters - exe - args
#
#--------------------------------------------------

sub get_book_title_file_arg
{
   return( $exe->get_arg_value( "book_title_file" ) );
}

