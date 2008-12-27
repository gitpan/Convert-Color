package Convert::Color;

use strict;

use Carp;

use Module::Pluggable require => 1,
                      search_path => [ 'Convert::Color' ];

our $VERSION = '0.01';

=head1 NAME

C<Convert::Color> - color space conversions and named lookups

=head1 SYNOPSIS

 use Convert::Color;

 my $color = Convert::Color->new( 'hsv:76,0.43,0.89' );

 my ( $red, $green, $blue ) = $color->rgb;

 # GTK uses 16-bit values
 my $gtk_col = Gtk2::Gdk::Color->new( $color->rgb16 );

 # HTML uses #rrggbb in hex
 my $html = '<td bgcolor="#' . $color->rgb8_hex . '">';

=head1 DESCRIPTION

This module provides conversions between commonly used ways to express colors.
It provides conversions between color spaces such as RGB and HSV, and it
provides ways to look up colors by a name.

This class provides a base for subclasses which represent particular color
values in particular spaces. The base class provides methods to represent the
color in a few convenient forms, though subclasses may provide more specific
details for the space in question.

For more detail, read the documentation on these classes; namely:

=over 4

=item *

L<Convert::Color::RGB> - red/green/blue as floats between 0 and 1

=item *

L<Convert::Color::RGB8> - red/green/blue as 8-bit integers

=item *

L<Convert::Color::RGB16> - red/green/blue as 16-bit integers

=item *

L<Convert::Color::HSV> - hue/saturation/value

=item *

L<Convert::Color::HSL> - hue/saturation/lightness

=back

The following classes are subclasses of one of the above, which provide a way
to access predefined colors by names:

=over 4

=item *

L<Convert::Color::VGA> - named lookup for the basic VGA colors

=item *

L<Convert::Color::X11> - named lookup of colors from X11's F<rgb.txt>

=back

=cut

=head1 CONSTRUCTOR

=cut

=head2 $color = Convert::Color->new( STRING )

Return a new value to represent the color specified by the string. This string
should be prefixed by the name of the color space to which it applies. For
example

 rgb:RED,GREEN,BLUE
 rgb8:RRGGBB
 rgb16:RRRRGGGGBBBB
 hsv:HUE,SAT,VAL
 hsl:HUE,SAT,LUM

 vga:NAME
 vga:INDEX

 x11:NAME

For more detail, see the constructor of the color space subclass in question.

=cut

sub new
{
   shift;
   my ( $str ) = @_;

   $str =~ m/^(\w+):(.*)$/ or croak "Unable to parse color name $str";
   ( my $space, $str ) = ( $1, $2 );

   foreach my $class ( Convert::Color->plugins ) {
      $class->can( 'COLOR_SPACE' ) or next;

      if( $class->COLOR_SPACE eq $space ) {
         return $class->new( $str );
      }
   }

   croak "Unrecognised color space name '$space'";
}

=head1 METHODS

=cut

=head2 ( $red, $green, $blue ) = $color->rgb

Returns the individual red, green and blue color components of the color
value. For RGB values, this is done directly. For values in other spaces, this
is done by first converting them to an RGB value using their C<to_rgb()>
method.

=cut

sub rgb
{
   my $self = shift;

   $self->can( 'as_rgb' ) or croak "Cannot express $self as an RGB triplet";

   my $rgb = $self->as_rgb;

   return $rgb->red, $rgb->green, $rgb->blue;
}

=head2 ( $red, $green, $blue ) = $color->rgb8

Returns the individual red, green and blue color components of the color
value in RGB8 space. For RGB8 values, this is done directly. For values in
other spaces, this is done by first converting them to an RGB value using
their C<to_rgb()> method, then converting that to RGB8.

=cut

sub rgb8
{
   my $self = shift;

   return map { int( $_ * 255 ) } $self->rgb;
}

=head2 ( $red, $green, $blue ) = $color->rgb16

Returns the individual red, green and blue color components of the color
value in RGB16 space. For RGB16 values, this is done directly. For values in
other spaces, this is done by first converting them to an RGB value using
their C<to_rgb()> method, then converting that to RGB16.

=cut

sub rgb16
{
   my $self = shift;

   return map { int( $_ * 0xffff ) } $self->rgb;
}

=head2 $str = $color->rgb8_hex

Returns a string representation of the color components in the RGB8 space, in
a convenient C<RRGGBB> hex string, likely to be useful HTML, or other similar
places.

=cut

sub rgb8_hex
{
   my $self = shift;
   sprintf "%02x%02x%02x", $self->rgb8;
}

=head2 $str = $color->rgb16_hex

Returns a string representation of the color components in the RGB16 space, in
a convenient C<RRRRGGGGBBBB> hex string.

=cut

sub rgb16_hex
{
   my $self = shift;
   sprintf "%04x%04x%04x", $self->rgb16;
}

=head1 COMMON METHODS OF SUBCLASSES

Most subclasses should support the following methods and behaviours. Note that
this list is just a guide; the documentation for the specific class in
question. As well as the following, it is likely the subclass will provide
accessors to directly obtain the components of its representation in the
specific space.

=cut

=head2 $color->as_rgb

Return a new value representing the color in RGB space

=cut

=head2 $color->as_rgb8

Return a new value representing the color in RGB8 space

=cut

sub as_rgb8
{
   my $self = shift;

   require Convert::Color::RGB8;

   return Convert::Color::RGB8->new( $self->rgb8 );
}

=head2 $color->as_rgb16

Return a new value representing the color in RGB16 space

=cut

sub as_rgb16
{
   my $self = shift;

   require Convert::Color::RGB16;

   return Convert::Color::RGB16->new( $self->rgb16 );
}

=head2 $color->as_hsv

Return a new value representing the color in HSV space

=cut

sub as_hsv
{
   my $self = shift;
   $self->as_rgb->as_hsv;
}

=head2 $color->as_hsl

Return a new value representing the color in HSL space

=cut

sub as_hsl
{
   my $self = shift;
   $self->as_rgb->as_hsl;
}

# Keep perl happy; keep Britain tidy
1;

__END__

=head1 AUTHOR

Paul Evans E<lt>leonerd@leonerd.org.ukE<gt>
