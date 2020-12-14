
use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   getCmdLineOptions
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
%opt_got = getCmdLineOptions( @opt_spec );
is_deeply( \%opt_got, \%opt_expect, "no args, no opts, empty optspec. opts" );
is_deeply( \@ARGV, \@argv_expect,   "no args, no opts, empty optspec. args" );





done_testing();

exit 0;
