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
   add_new_lines
   get_cmd_line_args
   get_cmd_line_options
   get_recursive_list_of_dirs
   get_recursive_list_of_files
   grep_strs_in_array
   nvl
   verify_dir_is_readable
);


my $SCRIPT = basename( $0 );

my @opt_spec = qw(
   help|h|H|?
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
               [-i|--ignore_case]
               [ [-fp|--file_pattern]=<file pattern> ...]
               <[-d|dirs] | [-f|files] | [both]>
               <dir>
               <string ...>

EOT

#--------------------------------------------------
#
# main
#
#--------------------------------------------------

# get cmd line
my %opts = get_cmd_line_options( @opt_spec );
my %args = get_cmd_line_args(    @arg_spec );
my $dir     = $args{ dir };
my @strings = $args{ strings };

#print "opts\n"; print Dumper( \%opts ) . "\n";
#print "args\n";print Dumper( \%args ) . "\n";

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

my @matched_files = grep_strs_in_array(
   strs        => \@strings,
   array       => \@filesys_list,
   ignore_case => $ignore_case,
);

# print matched items
print "\n";
print add_new_lines( @matched_files );


