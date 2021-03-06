#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;
use Test::Exception;

use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Exe;

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################


# empty new
lives_ok { new My::Objects::Exe() } "empty new ";

# single item array
throws_ok { new My::Objects::Exe( 1 ) } qr/Args is not a hash/, "single item array";

# even number array
lives_ok { new My::Objects::Exe( 1, 2 ) } "even number array";

# hash
lives_ok { new My::Objects::Exe( k1 => "v1", k2 => "v2" ) } "hash";


done_testing();

exit 0;
