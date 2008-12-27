package Convert::Color::RGB;

use strict;
use base qw( Convert::Color );

use constant COLOR_SPACE => 'rgb';

use List::Util qw( max min );

use Carp;

our $VERSION = '0.01';

=head1 NAME

C<Convert::Color::RGB> - a color value represented as red/green/blue

=head1 SYNOPSIS

Directly:

 use Convert::Color::RGB;

 my $red = Convert::Color::RGB->new( 1, 0, 0 );

 # Can also parse strings
 my $pink = Convert::Color::RGB->new( '1,0.7,0.7' );

Via L<Convert::Color>:

 use Convert::Color;

 my $cyan = Convert::Color->new( 'rgb:0,1,1' );

=head1 DESCRIPTION

Objects in this class represent a color in RGB space, as a set of three
floating-point values in the range 0 to 1.

For representations using 8- or 16-bit integers, see L<Convert::Color::RGB8>
and L<Convert::Color::RGB16>.

=cut

=head1 CONSTRUCTOR

=cut

=head2 $color = Convert::Color::RGB->new( $red, $green, $blue )

Returns a new object to represent the set of values given. These values should
be floating-point numbers between 0 and 1. Values outside of this range will
be clamped.

=head2 $color = Convert::Color::RGB->new( $string )

Parses C<$string> for values, and construct a new object similar to the above
three-argument form. The string should be in the form

 red,green,blue

containing the three floating-point values in decimal notation.

=cut

sub new
{
   my $class = shift;

   my ( $r, $g, $b );

   if( @_ == 1 ) {
      local $_ = $_[0];
      if( m/^(\d+(?:\.\d+)?),(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)$/ ) {
         ( $r, $g, $b ) = ( $1, $2, $3 );
      }
      else {
         croak "Unrecognised RGB string spec '$_'";
      }
   }
   elsif( @_ == 3 ) {
      ( $r, $g, $b ) = @_;
   }
   else {
      croak "usage: Convert::Color::RGB->new( SPEC ) or ->new( R, G, B )";
   }

   # Clamp to the range [0,1]
   map { $_ < 0 and $_ = 0; $_ > 1 and $_ = 1 } ( $r, $g, $b );

   return bless [ $r, $g, $b ], $class;
}

=head1 METHODS

=cut

=head2 $r = $color->red

=head2 $g = $color->green

=head2 $b = $color->blue

Accessors for the three components of the color.

=cut

# Simple accessors
sub red   { shift->[0] }
sub green { shift->[1] }
sub blue  { shift->[2] }

=head1 SUPPORTED CONVERSIONS

The following conversion methods are supported natively

=over 4

=cut

sub as_rgb { shift } # identity

# HSV and HSL are related, using some common elements.
# See also
#  http://en.wikipedia.org/wiki/HSV_color_space

sub _hue_min_max
{
   my $self = shift;

   my ( $r, $g, $b ) = @$self;

   my $max = max $r, $g, $b;
   my $min = min $r, $g, $b;

   my $hue;

   if( $max == $min ) {
      $hue = 0;
   }
   elsif( $max == $r ) {
      $hue = 60 * ( $g - $b ) / ( $max - $min );
   }
   elsif( $max == $g ) {
      $hue = 60 * ( $b - $r ) / ( $max - $min ) + 120;
   }
   elsif( $max == $b ) {
      $hue = 60 * ( $r - $g ) / ( $max - $min ) + 240;
   }

   return ( $hue, $min, $max );
}

=item C<as_hsv>

=cut

sub as_hsv
{
   my $self = shift;

   my ( $hue, $min, $max ) = $self->_hue_min_max;

   use Convert::Color::HSV;

   return Convert::Color::HSV->new(
      $hue,
      $max == 0 ? 0 : 1 - ( $min / $max ),
      $max
   );
}

=item C<as_hsl>

=cut

sub as_hsl
{
   my $self = shift;

   my ( $hue, $min, $max ) = $self->_hue_min_max;

   use Convert::Color::HSL;

   my $l = ( $max + $min ) / 2;

   my $s = $min == $max ? 0 :
           $l <= 1/2    ? ( $max - $min ) / ( 2 * $l ) :
                          ( $max - $min ) / ( 2 - 2 * $l );

   return Convert::Color::HSL->new( $hue, $s, $l );
}

=back

=cut

# Keep perl happy; keep Britain tidy
1;

__END__

=head1 SEE ALSO

=over 4

=item *

L<Convert::Color> - color space conversions

=item *

L<Convert::Color::HSV> - a color value represented as hue/saturation/value

=item *

L<Convert::Color::HSL> - a color value represented as hue/saturation/lightness

=back

=head1 AUTHOR

Paul Evans E<lt>leonerd@leonerd.org.ukE<gt>
