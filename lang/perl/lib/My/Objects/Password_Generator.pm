package My::Objects::Password_Generator;

use strict;
use warnings;
use Data::Dumper;

use Carp qw( cluck confess );

use lib "$FindBin::Bin/../../../../../lib";
use My::Constants qw(
   $YES
   $NO
);
use My::Utils qw(
   get_random_number
   is_array_cnt_even
   is_non_empty
   nvl
);


my $DEFAULT_MAX_PASSWORD_LEN = 10;
my $DEFAULT_MIN_PASSWORD_LEN = 10;
my $DEFAULT_NUM_PASSWORDS    = 1;

my $DEFAULT_DASH_GROUP_LEN   = 5;
my $DEFAULT_NUM_DASH_GROUPS  = 6;

#===============================================================
#
# class - public
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

#===============================================================
#
# instance - public
#
#===============================================================

sub get_dash_password
{
   my $self = shift;
   my %args = @_;
   
   my $num_groups = nvl( $args{ num_groups }, $DEFAULT_NUM_DASH_GROUPS );
   my $group_len  = nvl( $args{ group_len },  $DEFAULT_DASH_GROUP_LEN );

   my $grp_cnt = 0;
   my $password = "";
   while ( $grp_cnt < $num_groups )
   {
      my $str = $self->_get_random_str( $group_len );
      $password .= ( length( $password ) == 0 ? "" : "-" ) . $str;
      $grp_cnt++;
   }

   return( $password );
}

sub get_dash_passwords
{
   my $self = shift;
   my %args = @_;

   my $num_passwords = nvl( $args{ num_passwords }, $DEFAULT_NUM_PASSWORDS );
   $num_passwords > 0 or confess "ERROR. Num passwords is 0 or negative";

   my @arr = ();
   foreach ( 1 .. $num_passwords )
   {
      push( @arr, $self->get_dash_password( %args ) );
   }

   return( @arr );
}

sub get_password
{
   my $self = shift;
   my %args = @_;

   my $len = 0;
   if ( is_non_empty( $args{ len } ) )
   {
      $len = $args{ len };
   }
   else 
   {
      my $min_len = nvl( $args{ min_len }, $DEFAULT_MIN_PASSWORD_LEN );
      my $max_len = nvl( $args{ max_len }, $DEFAULT_MAX_PASSWORD_LEN );
      $len        = get_random_number( $min_len, $max_len );
   }

   my $passwd = $self->_get_random_str( $len );

   return( $passwd );
}

sub get_passwords
{
   my $self = shift;
   my %args = @_;

   my $num_passwords = nvl( $args{ num_passwords }, $DEFAULT_NUM_PASSWORDS );
   $num_passwords > 0 or confess "ERROR. Num passwords is 0 or negative";

   my @arr = ();
   foreach ( 1 .. $num_passwords )
   {
      push( @arr, $self->get_password( %args ) );
   }

   return( @arr );
}


#===============================================================
#
# instance - private
#
#===============================================================

sub _get_random_char
{
   my $self = shift;

   my $sel  = get_random_number( 0, 3 );
   my $char = "";

   if    ( $sel == 0 
            and $self->get_letters_setting()   eq $YES 
            and $self->get_lowercase_setting() eq $YES )
   {
      $char = $self->_get_random_lowercase_letter();
   }
   elsif ( $sel == 1 
            and $self->get_letters_setting()   eq $YES 
            and $self->get_uppercase_setting() eq $YES )
   {
      $char = $self->_get_random_uppercase_letter();
   }
   elsif ( $sel == 2 and $self->get_numbers_setting() eq $YES )
   {
      $char = $self->_get_random_digit();
   }
   elsif ( $sel == 3 and $self->get_symbols_setting() eq $YES )
   {
      $char = $self->_get_random_symbol();
   }

   return( $char );
}

sub _get_random_str
{
   my $self = shift;

   my $len = shift;

   my $str = "";
   while( length( $str ) < $len )
   {
      my $char = $self->_get_random_char();
      if ( is_non_empty( $char ) )
      {
         $str .= $char;
      }
   }
   return( $str );
}

sub _get_random_digit
{
   my $self = shift;

   my @arr = (
      #"0", # index 0
      #"1", # index 1
      "2", # index 2
      "3", # index 3
      "4", # index 4
      "5", # index 5
      "6", # index 6
      "7", # index 7
      "8", # index 8
      "9", # index 9
   );

   my $char = $arr[ get_random_number( 0, $#arr ) ];
   return( $char );
}

sub _get_random_lowercase_letter
{
   my $self = shift;

   my @arr = (
      "a", # index 0
      "b", # index 1
      "c", # index 2
      "d", # index 3
      "e", # index 4
      "f", # index 5
      "g", # index 6
      "h", # index 7
      #"i", # index 8
      "j", # index 9
      "k", # index 10
      #"l", # index 11
      "m", # index 12
      "n", # index 13
      #"o", # index 14
      "p", # index 15
      "q", # index 16
      "r", # index 17
      "s", # index 18
      "t", # index 19
      "u", # index 20
      "v", # index 21
      "w", # index 22
      "x", # index 23
      "y", # index 24
      "z", # index 25
   );

   my $char = $arr[ get_random_number( 0, $#arr ) ];
   return( $char );
}

sub _get_random_symbol
{
   my $self = shift;

   my @arr = (

      "~",  # index 0
      "!",  # index 1
      "@",  # index 2
      "#",  # index 3
      "\$", # index 4
      "%",  # index 5
      "^",  # index 6
      "&",  # index 7
      "*",  # index 8
      "(",  # index 9
      ")",  # index 10
      #"-",  # index 11
      "_",  # index 12
      "=",  # index 13
      "+",  # index 14
      "[",  # index 15
      "]",  # index 16
      "{",  # index 17
      "}",  # index 18
      "<",  # index 19
      ">",  # index 20
      "?",  # index 21
      ",",  # index 22
      ".",  # index 23
   );

   my $char = $arr[ get_random_number( 0, $#arr ) ];
   return( $char );
}

sub _get_random_uppercase_letter
{
    my $self = shift;

    my @arr = (
      "A", # index 0
      "B", # index 1
      "C", # index 2
      "D", # index 3
      "E", # index 4
      "F", # index 5
      "G", # index 6
      "H", # index 7
      #"I", # index 8
      "J", # index 9
      "K", # index 10
      "L", # index 11
      "M", # index 12
      "N", # index 13
      #"O", # index 14
      "P", # index 15
      #"Q", # index 16
      "R", # index 17
      "S", # index 18
      "T", # index 19
      "U", # index 20
      "V", # index 21
      "W", # index 22
      "X", # index 23
      "Y", # index 24
      "Z", # index 25
   );

   my $char = $arr[ get_random_number( 0, $#arr ) ];
   return( $char );
}

sub _init_obj
{
   my $self = shift;

   is_array_cnt_even( @_ ) or die "ERROR. Args is not a hash";

   my %args = @_;
   
   # set settings
   $self->_set_letters_setting(   nvl( $args{ letters },   $YES ) );
   $self->_set_numbers_setting(   nvl( $args{ numbers },   $YES ) );
   $self->_set_symbols_setting(   nvl( $args{ symbols },   $YES ) );
   $self->_set_uppercase_setting( nvl( $args{ uppercase }, $YES ) );
   $self->_set_lowercase_setting( nvl( $args{ lowercase }, $YES ) );
}

#---------------------------------------------------
#
# getters/setters - public
#
#---------------------------------------------------

sub get_letters_setting
{
   my $self = shift;
   return( $self->{ settings }->{ letters } );
}

sub get_lowercase_setting
{
   my $self = shift;
   return( $self->{ settings }->{ lowercase } );
}

sub get_numbers_setting
{
   my $self = shift;
   return( $self->{ settings }->{ numbers } );
}

sub get_symbols_setting
{
   my $self = shift;
   return( $self->{ settings }->{ symbols } );
}

sub get_uppercase_setting
{
   my $self = shift;
   return( $self->{ settings }->{ uppercase } );
}

#---------------------------------------------------
#
# getters/setters - private
#
#---------------------------------------------------

sub _set_letters_setting
{
   my $self = shift;
   my $value = shift;

   is_non_empty( $value ) or confess "Value is empty";
   $value eq $YES or $value eq $NO 
      or confess "Value is invalid. value=[$value]";

   $self->{ settings }->{ letters } = $value;
}

sub _set_lowercase_setting
{
   my $self = shift;
   my $value = shift;

   is_non_empty( $value ) or confess "Value is empty";
   $value eq $YES or $value eq $NO 
      or confess "Value is invalid. value=[$value]";

   $self->{ settings }->{ lowercase } = $value;
}

sub _set_numbers_setting
{
   my $self = shift;
   my $value = shift;

   is_non_empty( $value ) or confess "Value is empty";
   $value eq $YES or $value eq $NO 
      or confess "Value is invalid. value=[$value]";

   $self->{ settings }->{ numbers } = $value;
}

sub _set_symbols_setting
{
   my $self = shift;
   my $value = shift;

   is_non_empty( $value ) or confess "Value is empty";
   $value eq $YES or $value eq $NO 
      or confess "Value is invalid. value=[$value]";

   $self->{ settings }->{ symbols } = $value;
}

sub _set_uppercase_setting
{
   my $self = shift;
   my $value = shift;

   is_non_empty( $value ) or confess "Value is empty";
   $value eq $YES or $value eq $NO 
      or confess "Value is invalid. value=[$value]";

   $self->{ settings }->{ uppercase } = $value;
}


1;
