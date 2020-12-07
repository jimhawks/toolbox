
use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   ltrim
);

# regular non-padded values
is( ltrim(undef), "",    "undef");
is( ltrim(""),    "",    "empty string");
is( ltrim("abc"), "abc", "nonempty string");
is( ltrim(0),     0,     "zero");
is( ltrim(123),   123,   "multi digit int");
is( ltrim(12.3),  12.3,  "float");

# padded on the left only
is( ltrim(" abc"),   "abc",  "lpad only - 1 space");
is( ltrim("   abc"), "abc",  "lpad only - 2+ spaces");

# padded on the right only
is( ltrim("abc "),   "abc ",   "rpad only - 1 space");
is( ltrim("abc   "), "abc   ", "rpad only - 2+ spaces");

# padded on both sides
is( ltrim(" abc "),    "abc ",   "lrpad - 1 space");
is( ltrim("  abc   "), "abc   ", "lrpad - 2+ spaces");

# spaces in the middle
is( ltrim("  abc def  ghi  "), "abc def  ghi  ",   "middle spaces");

done_testing();

exit 0;
