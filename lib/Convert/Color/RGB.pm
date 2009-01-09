package Convert::Color::RGB;

use strict;
use base qw( Convert::Color );

use constant COLOR_SPACE => 'rgb';

use Carp;

our $VERSION = '0.02';

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

=head2 ( $red, $green, $blue ) = $color->rgb

Returns the individual red, green and blue color components of the color
value.

=cut

sub rgb
{
   my $self = shift;
   return @$self;
}

sub new_rgb
{
   my $class = shift;
   return $class->new( @_ );
}

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
