package My::Objects::Exe;

use strict;
use warnings;
use Data::Dumper;

use Carp qw( cluck confess );

use lib "$FindBin::Bin/../../../../../lib";
use My::Utils qw(
   is_non_empty
   nvl
);

#===============================================================
#
# public
#
#===============================================================

sub new
{
   my $class = shift;
   my $self  = { };
   bless $self, $class;

   $self->_initObj( @_ );

   return $self
}

#---------------------------------------------------

sub getArgs
{
   my $self = shift;

   if ( !exists( $self->{ args } ) )
   {
      $self->{ args } = { };
   }

   return( wantarray 
           ? %{ $self->{ args } } 
           : $self->{ args } 
   );
}

sub getData
{
   my $self = shift;

   if ( !exists( $self->{ data } ) )
   {
      $self->{ data } = { };
   }

   return( wantarray 
           ? %{ $self->{ data } } 
           : $self->{ data } 
   );
}

sub getOptions
{
   my $self = shift;

   if ( !exists( $self->{ options } ) )
   {
      $self->{ options } = { };
   }

   return( wantarray 
           ? %{ $self->{ options } } 
           : $self->{ options } 
   );
}

#---------------------------------------------------

sub setArgValue
{
   my $self = shift;

   my $key   = shift;
   my $value = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   $self->getArgs()->{ $key } = $value;
}

sub getArgValue
{
   my $self = shift;

   my $key = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   if ( !exists( $self->getArgs()->{ $key } ) )
   {
      $self->getArgs()->{ $key } = "";
   }

   return( $self->getArgs()->{ $key } );
}





#===============================================================
#
# private
#
#===============================================================

sub _initObj
{
   my $self = shift;
   my %args = @_;

   $args{ optSpec } = nvl( $args{ optSpec }, [] );
   $args{ argList } = nvl( $args{ argList }, [] );

   my @optSpec = @{ $args{ optSpec } };
   my @argList = @{ $args{ argList } };

   my %h1 = ();
   foreach my $arg ( @argList )
   {
      if ( $arg =~ /^@/ )
      {
         $arg =~ s/^@//;
         @{ $h1{ $arg } } = @ARGV;
         @ARGV = ();
         last;
      }
      $self->setArgValue( $arg, nvl( shift @ARGV, "" ) );
   }
}



1;
