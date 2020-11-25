package My::Utils::Strings;

use strict;
use warnings;

require Exporter;
our @ISA = qw( Exporter );

our @EXPORT = qw(
    isEmpty 
    isNonEmpty 
    nvl
);



sub isEmpty 
{
    my $rc = isStringNonEmpty( @_ ) ? 0 : 1;
    return( $rc );
}

sub isNonEmpty 
{
    my $str = shift;
    my $rc = ( defined( $str ) and length( $str ) > 0 ) ? 1 : 0;
    return( $rc );
}

sub getCmdLineOptions
{
   my @optionSpec = @_;

   my %options = ();


   return( %options );
}

sub nvl
{
   my $val     = shift;
   my $default = shift;
   return( isNonEmpty( $val ) ? $val : $default );
}

1;

