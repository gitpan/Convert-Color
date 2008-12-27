package Convert::Color::VGA;

use strict;
use base qw( Convert::Color::RGB );

use constant COLOR_SPACE => 'vga';

use Carp;

our $VERSION = '0.01';

=head1 NAME

C<Convert::Color::VGA> - named lookup for the basic VGA colors

=head1 SYNOPSIS

Directly:

 use Convert::Color::VGA;

 my $red = Convert::Color::VGA->new( 'red' );

 # Can also use index
 my $black = Convert::Color::VGA->new( 0 );

Via L<Convert::Color>:

 use Convert::Color;

 my $cyan = Convert::Color->new( 'vga:cyan' );

=head1 DESCRIPTION

This subclass of L<Convert::Color::RGB> provides predefined colors for the 8
basic VGA colors. Their names are

 black
 blue
 green
 cyan
 red
 magenta
 yellow
 white

They may be looked up either by name, or by numerical index within this list.

=cut

my %vga_colors = (
   black   => [ 0, 0, 0 ],
   blue    => [ 0, 0, 1 ],
   green   => [ 0, 1, 0 ],
   cyan    => [ 0, 1, 1 ],
   red     => [ 1, 0, 0 ],
   magenta => [ 1, 0, 1 ],
   yellow  => [ 1, 1, 0 ],
   white   => [ 1, 1, 1 ],
);

# Also indexes
my @vga_colors = qw(
   black blue green cyan red magenta yellow white
);

=head1 CONSTRUCTOR

=cut

=head2 $color = Convert::Color::VGA->new( $name )

Returns a new object to represent the named color.

=head2 $color = Convert::Color::VGA->new( $index )

Returns a new object to represent the color at the given index.

=cut

sub new
{
   my $class = shift;

   if( @_ == 1 ) {
      my $name = $_[0];

      if( $name =~ m/^\d+$/ ) {
         $name >= 0 and $name < @vga_colors or
            croak "No such VGA color at index $name";

         $name = $vga_colors[$name];
      }

      my $color = $vga_colors{$name} or
         croak "No such VGA color named '$name'";

      return $class->SUPER::new( @$color );
   }
   else {
      croak "usage: Convert::Color::VGA->new( NAME ) or ->new( INDEX )";
   }
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
