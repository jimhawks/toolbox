#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use TAP::Harness;

my @tests = ();

push( @tests, glob "../*/t/*/*.t" );
push( @tests, glob "../*/*/t/*/*.t" );
push( @tests, glob "../*/*/*/t/*/*.t" );
push( @tests, glob "../*/*/*/*/t/*/*.t" );
push( @tests, glob "../*/*/*/*/*/t/*/*.t" );
push( @tests, glob "../*/*/*/*/*/*/t/*/*.t" );
push( @tests, glob "../*/*/*/*/*/*/*/t/*/*.t" );

my %args = (
   verbosity => 1,
);

my $harness = TAP::Harness->new( \%args );
$harness->runtests( @tests );

exit 0;
