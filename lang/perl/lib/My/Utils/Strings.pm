package My::Utils::Strings;

use strict;
use warnings;

require Exporter;
our @ISA = qw( Exporter );

our @EXPORT = qw(
    isStringEmpty 
    isStringNonEmpty 
);



sub isStringEmpty 
{
    my $rc = isStringNonEmpty( @_ ) ? 0 : 1;
    return( $rc );
}

sub isStringNonEmpty 
{
    my $str = shift;
    my $rc = ( defined( $str ) and length( $str ) > 0 ) ? 1 : 0;
    return( $rc );
}


1;

