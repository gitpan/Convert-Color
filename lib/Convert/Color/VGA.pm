#  You may distribute under the terms of either the GNU General Public License
#  or the Artistic License (the same terms as Perl itself)
#
#  (C) Paul Evans, 2009,2010 -- leonerd@leonerd.org.uk

package Convert::Color::VGA;

use strict;
use warnings;
use base qw( Convert::Color::RGB );

__PACKAGE__->register_color_space( 'vga' );

use Carp;

our $VERSION = '0.07';

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

__PACKAGE__->register_palette(
   enumerate_once => sub {
      my $class = shift;
      map { $class->new( $_ ) } @vga_colors;
   },
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
      my ( $name, $index );

      if( $_[0] =~ m/^\d+$/ ) {
         $index = $_[0];
         $index >= 0 and $index < @vga_colors or
            croak "No such VGA color at index $index";

         $name = $vga_colors[$index];
      }
      else {
         $name = $_[0];
         $vga_colors[$_] eq $name and ( $index = $_, last ) for 0 .. 7;
         defined $index or croak "No such VGA color named '$name'";
      }

      my $self = $class->SUPER::new( @{ $vga_colors{$name} } );

      $self->[3] = $index;

      return $self;
   }
   else {
      croak "usage: Convert::Color::VGA->new( NAME ) or ->new( INDEX )";
   }
}

=head1 METHODS

=cut

=head2 $index = $color->index

The index of the VGA color.

=cut

sub index
{
   my $self = shift;
   return $self->[3];
}

=head2 $name = $color->name

The name of the VGA color.

=cut

sub name
{
   my $self = shift;
   return $vga_colors[$self->index];
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

Paul Evans <leonerd@leonerd.org.uk>
