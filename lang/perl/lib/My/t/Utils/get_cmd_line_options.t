#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   get_cmd_line_options
);

my @argv_start  = ();
my @argv_expect = ();
my @opt_spec    = ();
my %opt_got     = ();
my %opt_expect  = ();

#########
@argv_start = qw(
);
@opt_spec = qw(
);
%opt_expect = (
);
@argv_expect = qw(
);
@ARGV = @argv_start;
%opt_got = get_cmd_line_options( @opt_spec );
is_deeply( \%opt_got, \%opt_expect, "no args, no opts, empty optspec. opts" );
is_deeply( \@ARGV, \@argv_expect,   "no args, no opts, empty optspec. args" );

#########
@argv_start = qw(
   arg1
);
@opt_spec = qw(
);
%opt_expect = (
);
@argv_expect = qw(
   arg1
);
@ARGV = @argv_start;
%opt_got = get_cmd_line_options( @opt_spec );
is_deeply( \%opt_got, \%opt_expect, "1 arg, no opts, empty optspec. opts" );
is_deeply( \@ARGV, \@argv_expect,   "1 arg, no opts, empty optspec. args" );

#########
@argv_start = qw(
   arg1
   arg2
);
@opt_spec = qw(
);
%opt_expect = (
);
@argv_expect = qw(
   arg1
   arg2
);
@ARGV = @argv_start;
%opt_got = get_cmd_line_options( @opt_spec );
is_deeply( \%opt_got, \%opt_expect, "2 args, no opts, empty optspec. opts" );
is_deeply( \@ARGV, \@argv_expect,   "2 args, no opts, empty optspec. args" );

#########
@argv_start = qw(
   arg1
   arg2
);
@opt_spec = qw(
   opt1
);
%opt_expect = (
);
@argv_expect = qw(
   arg1
   arg2
);
@ARGV = @argv_start;
%opt_got = get_cmd_line_options( @opt_spec );
is_deeply( \%opt_got, \%opt_expect, "1+ args, no opts, nonempty optspec. opts" );
is_deeply( \@ARGV, \@argv_expect,   "1+ args, no opts, nonempty optspec. args" );

#########
@argv_start = qw(
   -opt90
   -opt1
   -opt91
   arg1
   arg2
);
@opt_spec = qw(
   opt1
);
%opt_expect = (
   opt1 => 1,
);
@argv_expect = qw(
   -opt90
   -opt91
   arg1
   arg2
);
@ARGV = @argv_start;
%opt_got = get_cmd_line_options( @opt_spec );
is_deeply( \%opt_got, \%opt_expect, "1+ args, 3 opt, 1 optspec. 1 spec match.  opts" );
is_deeply( \@ARGV, \@argv_expect,   "1+ args, 3 opt, 1 optspec. 1 spec match.  args" );





done_testing();

exit 0;
