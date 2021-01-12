package My::Objects::Exe;

use strict;
use warnings;
use Data::Dumper;

use Carp qw( cluck confess );

use lib "$FindBin::Bin/../../../../../lib";
use My::Utils qw(
   get_cmd_line_options
   is_array_cnt_even
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

   $self->_init_obj( @_ );

   return $self
}

#---------------------------------------------------

sub get_args
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

sub get_data
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

sub get_opts
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

sub get_arg_array
{
}

sub get_arg_value
{
   my $self = shift;

   my $key = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   if ( !exists( $self->get_args()->{ $key } ) )
   {
      $self->get_args()->{ $key } = "";
   }

   return( $self->get_args()->{ $key } );
}


sub get_data_array
{
}

sub set_data_array
{
}

sub get_data_hash
{
}

sub set_data_hash
{
}

sub get_data_value
{
}

sub set_data_value
{
}

sub get_opt_array
{
}

sub get_opt_value
{
}



#===============================================================
#
# private
#
#===============================================================

sub _init_obj
{
   my $self = shift;

   is_array_cnt_even( @_ ) or die "ERROR. Args is not a hash";

   my %args = @_;
   
   # initialize received args
   $args{ opt_spec } = nvl( $args{ opt_spec }, [] );
   $args{ arg_list } = nvl( $args{ arg_list }, [] );

   # copy arg arrays to local arrays for easier use
   my @opt_spec = @{ $args{ opt_spec } };
   my @arg_list = @{ $args{ arg_list } };

   # set options
   my %options = get_cmd_line_options( @opt_spec );
   foreach my $key ( sort keys %options )
   {
      $self->_set_opt( $key, $options{ $key } );
   }

   # set args
   foreach my $arg ( @arg_list )
   {
      # process array arg
      if ( $arg =~ /^@/ )
      {
         $arg =~ s/^@//;
         my @tmp = @ARGV;
         $self->_set_arg( $arg, \@tmp );
         @ARGV = ();
         last;
      }

      # skip unprocessed options
      my $value = "";
      while( 1 )
      {
         $value = nvl( shift @ARGV, "" );
         if ( $value !~ /^-/ )
         {
            last;
         }
      }

      # set arg
      $self->_set_arg( $arg, $value );
   }
}

sub _set_arg
{
   my $self = shift;

   my $key   = shift;
   my $value = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   $self->get_args()->{ $key } = $value;
}

sub _set_opt
{
   my $self = shift;

   my $key   = shift;
   my $value = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   $self->get_opts()->{ $key } = $value;
}



1;
