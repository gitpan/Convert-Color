#!/usr/bin/perl

use strict;

use Convert::Color;

print <<EOF;
<html>
 <body>
  <table border=1>
   <tr><th colspan=2>Name</th><th>RGB</th><th>HSL</th><th>CMYK</th></tr>
EOF

while( my $colour = shift @ARGV ) {
   if( $colour eq "x11:*" ) {
      require Convert::Color::X11;
      unshift @ARGV, map { "x11:$_" } sort Convert::Color::X11->colors;
      next;
   }

   my $c = Convert::Color->new( $colour );

   my $c_rgb8 = $c->as_rgb8;
   my $rgb8_hex = $c_rgb8->hex;

   my $rgb = join ",", $c_rgb8->rgb8;

   my $c_hsl = $c->as_hsl;
   my $hsl = sprintf "%.1f,%0.3f,%0.3f", $c_hsl->hsl;

   my $c_cmyk = $c->as_cmyk;
   my $cmyk = sprintf "%0.2f,%0.2f,%0.2f,%0.2f", $c_cmyk->cmyk;

   print <<"EOF";
    <tr><td>$colour</td><td bgcolor="#$rgb8_hex">&nbsp;&nbsp;&nbsp;</td><td>$rgb</td><td>$hsl</td><td>$cmyk</td></tr>
EOF

}

print <<EOF;
  </table>
 </body>
</html>
EOF
