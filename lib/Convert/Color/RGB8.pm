package Convert::Color::RGB8;

use strict;
use base qw( Convert::Color );

use constant COLOR_SPACE => 'rgb8';

use Carp;

our $VERSION = '0.01';

=head1 NAME

C<Convert::Color::RGB8> - a color value represented as red/green/blue in 8-bit
integers

=head1 SYNOPSIS

Directly:

 use Convert::Color::RGB8;

 my $red = Convert::Color::RGB8->new( 255, 0, 0 );

 # Can also parse strings
 my $pink = Convert::Color::RGB8->new( '255,192,192' );

 # or
 $pink = Convert::Color::RGB8->new( 'ffc0c0' );

Via L<Convert::Color>:

 use Convert::Color;

 my $cyan = Convert::Color->new( 'rgb8:0,255,255' );

=head1 DESCRIPTION

Objects in this class represent a color in RGB space, as a set of three
integer values in the range 0 to 255; i.e. as 8 bits.

For representations using floating point values, see L<Convert::Color::RGB>.
For representations using 16-bit integers, see L<Convert::Color::RGB16>.

=cut

=head1 CONSTRUCTOR

=cut

=head2 $color = Convert::Color::RGB8->new( $red, $green, $blue )

Returns a new object to represent the set of values given. These values should
be integers between 0 and 255. Values outside of this range will be clamped.

=head2 $color = Convert::Color::RGB8->new( $string )

Parses C<$string> for values, and construct a new object similar to the above
three-argument form. The string should be in the form

 red,green,blue

containing the three integer values in decimal notation. It can also be given
in the form of a hex encoded string, such as would be returned by the
C<rgb8_hex> method:

 rrggbb

=cut

sub new
{
   my $class = shift;

   my ( $r, $g, $b );

   if( @_ == 1 ) {
      local $_ = $_[0];
      if( m/^([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2})$/ ) {
         ( $r, $g, $b ) = ( hex $1, hex $2, hex $3 );
      }
      elsif( m/^(\d+),(\d+),(\d+)$/ ) {
         ( $r, $g, $b ) = ( $1, $2, $3 );
      }
      else {
         croak "Unrecognised RGB8 string spec '$_'";
      }
   }
   elsif( @_ == 3 ) {
      ( $r, $g, $b ) = @_;
   }
   else {
      croak "usage: Convert::Color::RGB8->new( SPEC ) or ->new( R, G, B )";
   }

   # Clamp to the range [0,255]
   map { $_ < 0 and $_ = 0; $_ > 255 and $_ = 255 } ( $r, $g, $b );

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

# Conversions
sub as_rgb
{
   my $self = shift;

   require Convert::Color::RGB;

   return Convert::Color::RGB->new( map { $_ / 255 } @$self );
}

# Shortcut
sub rgb8
{
   my $self = shift;
   return $self->red, $self->green, $self->blue;
}

# Keep perl happy; keep Britain tidy
1;

__END__

=head1 SEE ALSO

=over 4

=item *

L<Convert::Color> - color space conversions

=back

=head1 AUTHOR

Paul Evans E<lt>leonerd@leonerd.org.ukE<gt>
