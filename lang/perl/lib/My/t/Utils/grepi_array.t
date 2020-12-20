#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   grepi_array
);

my @lines_empty = ();
my @lines_1 = (
   "Four score and seven years ago our fathers brought forth, upon this continent",
);
my @lines_many = (
   "Four score and seven years",
   "Four score and seven years ago our fathers",
   "Four score and seven years ago our fathers brought forth",
   "Four score and seven years ago our fathers brought forth, upon this continent",
);

my @strs   = ();
my @got    = ();
my @expect = ();

#################################
@strs = (
);
@expect = (
);
@got = grepi_array( \@strs, \@lines_empty );
is_deeply( \@got, \@expect, "no strs, no lines");

#################################
@strs = (
);
@expect = (
);
@got = grepi_array( \@strs, \@lines_1 );
is_deeply( \@got, \@expect, "no strs, 1 line");

#################################
@strs = (
   "giraffe",
);
@expect = (
);
@got = grepi_array( \@strs, \@lines_empty );
is_deeply( \@got, \@expect, "1 str, no line");

#################################
@strs = (
   "giraffe",
);
@expect = (
);
@got = grepi_array( \@strs, \@lines_1 );
is_deeply( \@got, \@expect, "1 str, 1 line, no match");

#################################
@strs = (
   "father",
);
@expect = (
   "Four score and seven years ago our fathers brought forth, upon this continent",
);
@got = grepi_array( \@strs, \@lines_1 );
is_deeply( \@got, \@expect, "1 str, 1 line, yes match, case match");

#################################
@strs = (
   "FAtHer",
);
@expect = (
   "Four score and seven years ago our fathers brought forth, upon this continent",
);
@got = grepi_array( \@strs, \@lines_1 );
is_deeply( \@got, \@expect, "1 str, 1 line, yes match, case mismatch");

#################################
@strs = (
   "father",
   "FOUR",
);
@expect = (
   "Four score and seven years ago our fathers brought forth, upon this continent",
);
@got = grepi_array( \@strs, \@lines_1 );
is_deeply( \@got, \@expect, "2 str, 1 line, yes match, mixed case matching");

#################################
@strs = (
   "FAtHer",
   "four",
);
@expect = (
   "Four score and seven years ago our fathers brought forth, upon this continent",
);
@got = grepi_array( \@strs, \@lines_1 );
is_deeply( \@got, \@expect, "2 str, 1 line, yes match, case mismatch");

#################################
@strs = (
   "FAtHer",
   "giraffe",
   "four",
);
@expect = (
);
@got = grepi_array( \@strs, \@lines_1 );
is_deeply( \@got, \@expect, "3 str, 1 line, no match, 2nd doesnt match");

#################################
@strs = (
   "FAtHer",
   "four",
   "giraffe",
);
@expect = (
);
@got = grepi_array( \@strs, \@lines_1 );
is_deeply( \@got, \@expect, "3 str, 1 line, no match, 3rd doesnt match");

#################################
@strs = (
   "FATHER",
);
@expect = (
   "Four score and seven years ago our fathers",
   "Four score and seven years ago our fathers brought forth",
   "Four score and seven years ago our fathers brought forth, upon this continent",
);
@got = grepi_array( \@strs, \@lines_many );
is_deeply( \@got, \@expect, "1 str, 2+ lines, match multiple lines");

#################################
@strs = (
   "FATHER",
   "brought",
);
@expect = (
   "Four score and seven years ago our fathers brought forth",
   "Four score and seven years ago our fathers brought forth, upon this continent",
);
@got = grepi_array( \@strs, \@lines_many );
is_deeply( \@got, \@expect, "2 str, 2+ lines, match multiple lines");

#################################
@strs = (
   "FATHER",
   "brought",
   "continen",
);
@expect = (
   "Four score and seven years ago our fathers brought forth, upon this continent",
);
@got = grepi_array( \@strs, \@lines_many );
is_deeply( \@got, \@expect, "3 str, 2+ lines, match 1 line");

#################################
@strs = (
   "FATHER",
   "brought",
   "continen",
   "nation",
);
@expect = (
);
@got = grepi_array( \@strs, \@lines_many );
is_deeply( \@got, \@expect, "4 str, 2+ lines, match 0 lines");

#################################
@strs = (
   "continen",
   "continen",
   "continen",
);
@expect = (
   "Four score and seven years ago our fathers brought forth, upon this continent",
);
@got = grepi_array( \@strs, \@lines_many );
is_deeply( \@got, \@expect, "3 str, all the same");


done_testing();

exit 0;
