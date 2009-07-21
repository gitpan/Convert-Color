#  You may distribute under the terms of either the GNU General Public License
#  or the Artistic License (the same terms as Perl itself)
#
#  (C) Paul Evans, 2009 -- leonerd@leonerd.org.uk

package Convert::Color;

use strict;
use warnings;

use Carp;

use Module::Pluggable require => 1,
                      search_path => [ 'Convert::Color' ];
my @plugins = Convert::Color->plugins;

our $VERSION = '0.05';

=head1 NAME

C<Convert::Color> - color space conversions and named lookups

=head1 SYNOPSIS

 use Convert::Color;

 my $color = Convert::Color->new( 'hsv:76,0.43,0.89' );

 my ( $red, $green, $blue ) = $color->rgb;

 # GTK uses 16-bit values
 my $gtk_col = Gtk2::Gdk::Color->new( $color->as_rgb16->rgb16 );

 # HTML uses #rrggbb in hex
 my $html = '<td bgcolor="#' . $color->as_rgb8->hex . '">';

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

=item *

L<Convert::Color::CMY> - cyan/magenta/yellow

=item *

L<Convert::Color::CMYK> - cyan/magenta/yellow/key (blackness)

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

my %_space2class_cache; # {$space} = $class
sub _space2class
{
   my ( $space ) = @_;

   return $_space2class_cache{$space} if exists $_space2class_cache{$space};

   foreach my $class ( @plugins ) {
      $class->can( 'COLOR_SPACE' ) or next;

      return $_space2class_cache{$space} = $class if $class->COLOR_SPACE eq $space;
   }

   return undef;
}

=head2 $color = Convert::Color->new( STRING )

Return a new value to represent the color specified by the string. This string
should be prefixed by the name of the color space to which it applies. For
example

 rgb:RED,GREEN,BLUE
 rgb8:RRGGBB
 rgb16:RRRRGGGGBBBB
 hsv:HUE,SAT,VAL
 hsl:HUE,SAT,LUM
 cmy:CYAN,MAGENTA,YELLOW
 cmyk:CYAN,MAGENTA,YELLOW,KEY

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

   my $class = _space2class( $space ) or croak "Unrecognised color space name '$space'";

   return $class->new( $str );
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
   croak "Abstract method - should be overloaded by ".ref($self);
}

=head1 COLOR SPACE CONVERSIONS

Cross-conversion between color spaces is provided by the C<convert_to()>
method, assisted by helper methods in the two color space classes involved.

When converting C<$color> from color space SRC to color space DEST, the
following operations are attemped, in this order. SRC and DEST refer to the
names of the color spaces, e.g. C<rgb>.

=over 4

=item 1.

If SRC and DEST are equal, return C<$color> as it stands.

=item 2.

If the SRC space's class provides a C<convert_to_DEST> method, use it.

=item 3.

If the DEST space's class provides a C<new_from_SRC> constructor, call it and
pass C<$color>.

=item 4.

If the DEST space's class provides a C<new_rgb> constructor, convert C<$color>
to red/green/blue components then call it.

=item 5.

If none of these operations worked, then throw an exception.

=back

These functions may be called in the following ways:

 $other = $color->convert_to_DEST()
 $other = Dest::Class->new_from_SRC( $color )
 $other = Dest::Class->new_rgb( $color->rgb )

=cut

=head2 $other = $color->convert_to( $space )

Attempt to convert the color into its representation in the given space. See
above for the various ways this may be achieved.

=cut

sub convert_to
{
   my $self = shift;
   my ( $to_space ) = @_;

   my $to_class = _space2class( $to_space ) or croak "Unrecognised color space name '$to_space'";

   my $from_space = ref($self)->COLOR_SPACE;

   if( $from_space eq $to_space ) {
      # Identity conversion
      return $self;
   }

   my $code;
   if( $code = $self->can( "convert_to_$to_space" ) ) {
      return $code->( $self );
   }
   elsif( $code = $to_class->can( "new_from_$from_space" ) ) {
      return $code->( $to_class, $self );
   }
   elsif( $code = $to_class->can( "new_rgb" ) ) {
      # TODO: check that $self->rgb is overloaded
      return $code->( $to_class, $self->rgb );
   }
   else {
      croak "Cannot convert from space '$from_space' to space '$to_space'";
   }
}

# Fallback implementations in case subclasses don't provide anything better

sub convert_to_rgb
{
   my $self = shift;
   require Convert::Color::RGB;
   return Convert::Color::RGB->new( $self->rgb );
}

=head1 AUTOLOADED CONVERSION METHODS

This class provides C<AUTOLOAD> and C<can> behaviour which automatically
constructs conversion methods. The following method calls are identical:

 $color->convert_to('rgb')
 $color->as_rgb

The generated method will be stored in the package, so that future calls will
not have the AUTOLOAD overhead.

=cut

# Since this is AUTOLOADed, we can dynamically provide new methods for classes
# discovered at runtime.

sub can
{
   my $self = shift;
   my ( $method ) = @_;

   if( $method =~ m/^as_(.*)$/ ) {
      my $to_space = $1;
      _space2class( $to_space ) or return undef;

      return sub {
         my $self = shift;
         return $self->convert_to( $to_space );
      };
   }

   return $self->SUPER::can( $method );
}

sub AUTOLOAD
{
   my ( $method ) = our $AUTOLOAD =~ m/::([^:]+)$/;

   return if $method eq "DESTROY";

   if( my $code = $_[0]->can( $method ) ) {
      no strict 'refs';
      *{$method} = $code;
      goto &$code;
   }

   croak "$_[0] cannot do $method";
}

=head1 OTHER METHODS

As well as the above, it is likely the subclass will provide accessors to
directly obtain the components of its representation in the specific space.
For more detail, see the documentation for the specific subclass in question.

=cut

# Keep perl happy; keep Britain tidy
1;

__END__

=head1 AUTHOR

Paul Evans <leonerd@leonerd.org.uk>
