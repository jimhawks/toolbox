#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   add_new_lines
);

my @input  = ();
my @expect = ();
my @got    = ();


##############################
@input = (
);
@expect = (
);
@got = add_new_lines( @input );
is_deeply( \@got, \@expect, "no lines");


##############################
@input = (
   "this is line 1",
);
@expect = (
   "this is line 1\n",
);
@got = add_new_lines( @input );
is_deeply( \@got, \@expect, "1 line, no newlines");


##############################
@input = (
   "this is line 1",
   "this is line 2",
);
@expect = (
   "this is line 1\n",
   "this is line 2\n",
);
@got = add_new_lines( @input );
is_deeply( \@got, \@expect, "1+ lines, no newlines");


##############################
@input = (
   "this is line 1\n",
   "this is line 2",
);
@expect = (
   "this is line 1\n\n",
   "this is line 2\n",
);
@got = add_new_lines( @input );
is_deeply( \@got, \@expect, "1+ lines, has newlines");


##############################
@input = (
   "this is line 1",
   undef,
   "this is line 2",
   "",
);
@expect = (
   "this is line 1\n",
   undef,
   "this is line 2\n",
   "\n",
);
@got = add_new_lines( @input );
is_deeply( \@got, \@expect, "undef, empty line");



done_testing();

exit 0;
