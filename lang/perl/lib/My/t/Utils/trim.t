
use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   trim
);

# regular non-padded values
is( trim(undef), "",    "undef");
is( trim(""),    "",    "empty string");
is( trim("abc"), "abc", "nonempty string");
is( trim(0),     0,     "zero");
is( trim(123),   123,   "multi digit int");
is( trim(12.3),  12.3,  "float");

# padded on the left only
is( trim(" abc"),   "abc",   "lpad only - 1 space");
is( trim("   abc"), "abc", "lpad only - 2+ spaces");

# padded on the right only
is( trim("abc "),   "abc", "rpad only - 1 space");
is( trim("abc   "), "abc", "rpad only - 2+ spaces");

# padded on both sides
is( trim(" abc "),    "abc",   "lrpad - 1 space");
is( trim("  abc   "), "abc", "lrpad - 2+ spaces");

# spaces in the middle
is( trim("  abc def  ghi  "), "abc def  ghi", "middle spaces");

done_testing();

exit 0;
