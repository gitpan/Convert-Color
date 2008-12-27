package Convert::Color::X11;

use strict;
use base qw( Convert::Color::RGB8 );

use constant COLOR_SPACE => 'x11';

use Carp;

our $VERSION = '0.01';

our $RGB_TXT = '/usr/share/X11/rgb.txt';

=head1 NAME

C<Convert::Color::X11> - named lookup of colors from X11's F<rgb.txt>

=head1 SYNOPSIS

Directly:

 use Convert::Color::X11;

 my $red = Convert::Color::X11->new( 'red' );

Via L<Convert::Color>:

 use Convert::Color;

 my $cyan = Convert::Color->new( 'x11:cyan' );

=head1 DESCRIPTION

This subclass of L<Convert::Color::RGB8> provides lookup of color names
provided by X11's F<rgb.txt> file.

=cut

my $x11_colors;

=head1 CLASS METHODS

=cut

=head2 @colors = Convert::Color::X11->colors

Returns a list of the defined color names. This is a list of hash keys, so is
returned in no particular order.

=head2 $num_colors = Convert::Color::X11->colors

When called in scalar context, this method returns the count of the number of
defined colors.

=cut

sub colors
{
   my $class = shift;

   $x11_colors ||= _load_x11_colors();

   return keys %$x11_colors;
}

=head1 CONSTRUCTOR

=cut

=head2 $color = Convert::Color::X11->new( $name )

Returns a new object to represent the named color.

=cut

sub new
{
   my $class = shift;

   if( @_ == 1 ) {
      my $name = $_[0];

      $x11_colors ||= _load_x11_colors();

      my $color = $x11_colors->{$name} or
         croak "No such X11 color named '$name'";

      return $class->SUPER::new( @$color );
   }
   else {
      croak "usage: Convert::Color::X11->new( NAME )";
   }
}

sub _load_x11_colors
{
   my %colors;

   open( my $colorfh, "<", $RGB_TXT ) or
      die "Cannot read $RGB_TXT - $!\n";

   local $_;

   while( <$colorfh> ) {
      s/^\s+//; # trim leading WS
      next if m/^!/; # comment

      my ( $r, $g, $b, $name ) = m/^(\d+)\s+(\d+)\s+(\d+)\s+(.*)$/ or next;

      $colors{$name} = [ $r, $g, $b ];
   }

   return \%colors;
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
