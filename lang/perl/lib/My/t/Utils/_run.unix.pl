#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use TAP::Harness;

my @tests = qw(
   isEmpty.t
   isNonEmpty.t
   ltrim.t
   nvl.t
   rtrim.t
   trim.t
);

my %args = (
   verbosity => 1,
);

my $harness = TAP::Harness->new( \%args );
$harness->runtests( @tests );

exit 0;
