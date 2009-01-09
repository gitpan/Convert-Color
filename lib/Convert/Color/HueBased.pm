package Convert::Color::HueBased;

use strict;
use base qw( Convert::Color );

# No space name since we're not a complete space

use List::Util qw( max min );

# HSV and HSL are related, using some common elements.
# See also
#  http://en.wikipedia.org/wiki/HSV_color_space

sub _hue_min_max
{
   my $class = shift;
   my ( $r, $g, $b ) = @_;

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

# Keep perl happy; keep Britain tidy
1;
