#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   nvl
);

# values
is( nvl(undef, "rst"), "rst", "undef");
is( nvl("",    "rst"), "",    "empty string");
is( nvl("abc", "rst"), "abc", "nonempty string");
is( nvl(0,     "rst"), 0,     "zero");
is( nvl(123,   "rst"), 123,   "multi digit int");
is( nvl(12.3,  "rst"), 12.3,  "float");

# hash refs
my $null_href    = undef;
my $nonnull_href = { k1 => "v1", k2 => "v2" };
my $default_href = { k3 => "v3", k4 => "v4" };
is( nvl($null_href,    $default_href),  $default_href, "undef hash ref");
is( nvl($nonnull_href, $default_href),  $nonnull_href, "non-undef hash ref");

# array refs
my $null_aref    = undef;
my $nonnull_aref = { "v1", "v2" };
my $default_aref = { "v3", "v4" };
is( nvl($null_aref,    $default_aref),  $default_aref, "undef array ref");
is( nvl($nonnull_aref, $default_aref),  $nonnull_aref, "non-undef array ref");

done_testing();

exit 0;
