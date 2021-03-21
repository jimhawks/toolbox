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
use lib "$FindBin::RealBin/../lib";
use My::Utils qw(
   add_dbg_var
   add_new_lines
   dump_dbg_vars
   get_cmd_line_args
   get_cmd_line_options
   get_recursive_list_of_dirs
   get_recursive_list_of_files
   grep_strs_in_array
   grepv_strs_in_array
   nvl
   verify_dir_is_readable
);


my $SCRIPT = basename( $0 );

my @opt_spec = qw(
   help|h|H|?
   debug|dbg
   ignore_case|i
   file_pattern|fp=s@
   dirs|d
   files|f
);

my @arg_spec = qw(
   dir
   strings@
);

my $help = <<EOT;

$SCRIPT: get a list of files/dirs.  grep the list.

usage: $SCRIPT [-h|-H|-?|--help] 
               [debug|dbg];
               [-i|--ignore_case]
               [ [-fp|--file_pattern]=<file pattern> ...]
               <[-d|dirs] | [-f|files] | [both]>
               <dir>
               <string ...>

EOT

my %dbg = ();

#--------------------------------------------------
#
# main
#
#--------------------------------------------------

# get cmd line
my %opts = get_cmd_line_options( @opt_spec );
my %args = get_cmd_line_args(    @arg_spec );
my $dir     = $args{ dir };
my @strings = @{ $args{ strings } };

add_dbg_var( "cmdline", '%opts', \%opts );
add_dbg_var( "cmdline", '%args', \%args );
add_dbg_var( "copied_args", '$dir',  \$dir );
add_dbg_var( "copied_args", '@strings', \@strings );

$opts{ debug } and dump_dbg_vars();

if ( $opts{ help } )
{
   print $help;
   exit 0;
}

# process options
my $ignore_case = nvl( $opts{ ignore_case }, 0 );
my @file_patterns = @{ nvl( $opts{ file_pattern }, [ "*" ] ) };
my $incl_dirs  = nvl( $opts{ dirs }, 0 );
my $incl_files = nvl( $opts{ files }, 0 );

add_dbg_var( "processed_opts", '$ignore_case',  \$ignore_case );
add_dbg_var( "processed_opts", '@file_patterns',  \@file_patterns );
add_dbg_var( "processed_opts", '$incl_dirs',  \$incl_dirs );
add_dbg_var( "processed_opts", '$incl_files',  \$incl_files );

# separate strings to include and exclude strings
my @incl_strings = ();
my @excl_strings = ();
add_dbg_var( "sorted_strings", '@incl_strings', \@incl_strings );
add_dbg_var( "sorted_strings", '@excl_strings', \@excl_strings );
foreach my $str ( @strings )
{
   if ( $str =~ /^v:/ )
   {
      $str =~ s/^v://;
      push( @excl_strings, $str );
   }
   else
   {
      push( @incl_strings, $str );
   }
}

$opts{ debug } and dump_dbg_vars();

# validate dir
verify_dir_is_readable( $dir ) or confess "ERROR. dir not readable. dir=[$dir]";

# get filesys list and scan for strings
my @filesys_list = ();
if ( $incl_files )
{
   my @tmp = get_recursive_list_of_files(
      dir      => $dir,
      patterns => \@file_patterns,
   );
   push( @filesys_list, @tmp );
}
if ( $incl_dirs )
{
   my @tmp = get_recursive_list_of_dirs(
      dir      => $dir,
      patterns => \@file_patterns,
   );
   push( @filesys_list, @tmp );
}

my @filtered = @filesys_list;
if ( $#incl_strings >= 0 )
{
   my @tmp = grep_strs_in_array(
      strs        => \@incl_strings,
      array       => \@filtered,
      ignore_case => $ignore_case,
   );
   @filtered = @tmp;
}
if ( $#excl_strings >= 0 )
{
   my @tmp = grepv_strs_in_array(
      strs        => \@excl_strings,
      array       => \@filtered,
      ignore_case => $ignore_case,
   );
   @filtered = @tmp;
}

# print matched items
print "\n";
print add_new_lines( @filtered );


