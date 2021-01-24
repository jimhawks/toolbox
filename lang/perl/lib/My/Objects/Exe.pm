package My::Objects::Exe;

use strict;
use warnings;
use Data::Dumper;

use Carp qw( cluck confess );
use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   get_cmd_line_options
   is_array_cnt_even
   is_hash_empty
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

sub is_any_args
{
   my $self = shift;

   my %hash = $self->get_args();
   return( is_hash_empty( %hash ) );
}

sub is_any_opts
{
   my $self = shift;

   my %hash = $self->get_opts();
   return( is_hash_empty( %hash ) );
}

#---------------------------------------------------

sub get_arg_array
{
   my $self = shift;

   my $key = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   if ( !exists( $self->get_args()->{ $key } ) )
   {
      $self->get_args()->{ $key } = [];
   }

   return( wantarray 
           ? @{ $self->get_args()->{ $key } }
           : $self->get_args()->{ $key } 
   );
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
   my $self = shift;

   my $key = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   if ( !exists( $self->get_data()->{ $key } ) )
   {
      $self->get_data()->{ $key } = [];
   }

   return( wantarray 
           ? @{ $self->get_data()->{ $key } }
           : $self->get_data()->{ $key } 
   );
}

sub set_data_array
{
   my $self = shift;

   my $key = shift;
   my @arr = @_;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   $self->get_data()->{ $key } = \@arr;
}

sub get_data_hash
{
   my $self = shift;

   my $key = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   if ( !exists( $self->get_data()->{ $key } ) )
   {
      $self->get_data()->{ $key } = { };
   }

   return( wantarray 
           ? %{ $self->get_data()->{ $key } }
           : $self->get_data()->{ $key } 
   );
}

sub set_data_hash
{
   my $self = shift;

   my $key  = shift;
   my %hash = @_;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   $self->get_data()->{ $key } = \%hash;
}

sub get_data_value
{
   my $self = shift;

   my $key = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   if ( !exists( $self->get_data()->{ $key } ) )
   {
      $self->get_data()->{ $key } = "";
   }

   return( $self->get_data()->{ $key } );
}

sub set_data_value
{
   my $self = shift;

   my $key   = shift;
   my $value = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   $self->get_data()->{ $key } = $value;
}

sub get_opt_array
{
   my $self = shift;

   my $key = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   if ( !exists( $self->get_opts()->{ $key } ) )
   {
      $self->get_opts()->{ $key } = undef;
   }
   defined( $self->get_opts()->{ $key } ) or return( undef );

   return( wantarray 
           ? @{ $self->get_opts()->{ $key } }
           : $self->get_opts()->{ $key } 
   );
}

sub get_opt_value
{
   my $self = shift;

   my $key = shift;

   is_non_empty( $key ) or die "ERROR. Key is empty";

   if ( !exists( $self->get_opts()->{ $key } ) )
   {
      $self->get_opts()->{ $key } = undef; 
   }

   return( $self->get_opts()->{ $key } );
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

   # set options and args
   $self->_init_set_options( @{ $args{ opt_spec } } );
   $self->_init_set_args(    @{ $args{ arg_list } } );

}

sub _init_set_args
{
   my $self = shift;
   my @arg_list = @_;

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

sub _init_set_options
{
   my $self = shift;
   my @opt_spec = @_;

   # create map of the short options to the long options
   my %short_map = ();
   foreach my $spec ( @opt_spec )
   {
      my ( $name, $other )  = split( /[:=]/, $spec );
      my ( $lname, $sname ) = split( /\|/, $name );
      if ( is_non_empty( $sname ) )
      {
         is_non_empty( $lname ) or confess "Lname is empty";
         $short_map{ $sname } = $lname;
      }
   }
   
   # get options from cmd line
   my %options = get_cmd_line_options( @opt_spec );

   # copy short options to long options
   my %options2 = ();
   foreach my $key ( sort keys %options )
   {
      if ( exists( $short_map{ $key } ) )
      {
         my $long_name = $short_map{ $key } ;
         is_non_empty( $long_name ) or confess "Long name is empty";
         $options2{ $long_name }  = $options{ $key };
         next;
      }

      $options2{ $key }  = $options{ $key };
   }

   # set option values in obj
   foreach my $key ( sort keys %options2 )
   {
      $self->_set_opt( $key, $options{ $key } );
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
