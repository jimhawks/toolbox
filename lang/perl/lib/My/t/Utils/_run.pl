#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use TAP::Harness;

my @tests = qw(
   add_new_lines.t
   get_cmd_line_options.t
   get_dir_list.t
   get_file_list.t
   get_filesys_list.t
   grepi_array.t
   is_array_cnt_even.t
   is_empty.t
   is_non_empty.t
   ltrim.t
   nvl.t
   read_file.t
   rtrim.t
   trim.t
);

my %args = (
   verbosity => 1,
);

my $harness = TAP::Harness->new( \%args );
$harness->runtests( @tests );

exit 0;
