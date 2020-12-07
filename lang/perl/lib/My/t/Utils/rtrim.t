
use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   rtrim
);

# regular non-padded values
is( rtrim(undef), "",    "undef");
is( rtrim(""),    "",    "empty string");
is( rtrim("abc"), "abc", "nonempty string");
is( rtrim(0),     0,     "zero");
is( rtrim(123),   123,   "multi digit int");
is( rtrim(12.3),  12.3,  "float");

# padded on the left only
is( rtrim(" abc"),   " abc",   "lpad only - 1 space");
is( rtrim("   abc"), "   abc", "lpad only - 2+ spaces");

# padded on the right only
is( rtrim("abc "),   "abc", "rpad only - 1 space");
is( rtrim("abc   "), "abc", "rpad only - 2+ spaces");

# padded on both sides
is( rtrim(" abc "),    " abc",   "lrpad - 1 space");
is( rtrim("  abc   "), "  abc", "lrpad - 2+ spaces");

# spaces in the middle
is( rtrim("  abc def  ghi  "), "  abc def  ghi",   "middle spaces");

done_testing();

exit 0;
