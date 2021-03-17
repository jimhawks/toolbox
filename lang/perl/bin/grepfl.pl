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
use My::Utils qw(
   add_new_lines
   get_cmd_line_options
   get_recursive_list_of_files
   grep_strs_in_array
   nvl
   verify_dir_is_readable
);


my @opt_spec = qw(
   ignore_case|i
   file_pattern|fp=s@
);

#--------------------------------------------------
#
# main
#
#--------------------------------------------------

# get cmd line
my %opts = get_cmd_line_options( @opt_spec );
my $dir  = shift @ARGV;
my @strings = @ARGV;

# process options
my $ignore_case = nvl( $opts{ ignore_case }, 0 );
my @file_patterns = @{ nvl( $opts{ file_pattern }, [ "*" ] ) };

# validate dir
verify_dir_is_readable( $dir ) or confess "ERROR. dir not readable. dir=[$dir]";

# get file list and scan for strings
my @file_list = get_recursive_list_of_files(
   dir      => $dir,
   patterns => \@file_patterns,
);
my @matched_files = grep_strs_in_array(
   strs        => \@strings,
   array       => \@file_list,
   ignore_case => $ignore_case,
);

print "\n";
print add_new_lines( @matched_files );


