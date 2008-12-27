#!/usr/bin/perl

use strict;

use Convert::Color;

print <<EOF;
<html>
 <body>
  <table border=1>
   <tr><th colspan=2>Name</th><th>RGB</th><th>HSL</th></tr>
EOF

while( my $colour = shift @ARGV ) {
   if( $colour eq "x11:*" ) {
      require Convert::Color::X11;
      unshift @ARGV, map { "x11:$_" } sort Convert::Color::X11->colors;
      next;
   }

   my $c = Convert::Color->new( $colour );

   my $rgb = join ",", $c->rgb8;

   my $c_hsl = $c->as_hsl;
   my $hsl = sprintf "%.1f,%0.3f,%0.3f", $c_hsl->hue, $c_hsl->saturation, $c_hsl->lightness;

   my $rgb8_hex = $c->rgb8_hex;

   print <<"EOF";
    <tr><td>$colour</td><td bgcolor="#$rgb8_hex">&nbsp;&nbsp;&nbsp;</td><td>$rgb</td><td>$hsl</td></tr>
EOF

}

print <<EOF;
  </table>
 </body>
</html>
EOF
