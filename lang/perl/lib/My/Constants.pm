package My::Constants;

use strict;
use warnings;
use Data::Dumper;

use Carp qw( cluck confess );
use File::Find;
use Getopt::Long;
Getopt::Long::Configure( "pass_through" );

no warnings "File::Find";

require Exporter;
our @ISA = qw( Exporter );

our @EXPORT = qw(
   $TRUE
   $FALSE

   $YES
   $NO
);

our $TRUE  = 1;
our $FALSE = 0;

our $YES = "y";
our $NO  = "n";

1;
