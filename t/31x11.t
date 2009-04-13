#!/usr/bin/perl

use Convert::Color::X11;

require Test::More;

if( eval { Convert::Color::X11->colors; 1 } ) {
   import Test::More tests => 10;
}
else {
   import Test::More skip_all => "Cannot load X11 rgb.txt database";
}

ok( Convert::Color::X11->colors > 0, 'colors is > 0' );

my $red = Convert::Color::X11->new( 'red' );

is( $red->red,   255, 'red red' );
is( $red->green,   0, 'red green' );
is( $red->blue,    0, 'red blue' );

is( $red->name, "red", 'red name' );

is_deeply( [ $red->as_rgb8->rgb8 ], [ 255, 0, 0 ], 'red as_rgb8' );

my $green = Convert::Color->new( 'x11:green' );

is( $green->red,     0, 'green red' );
is( $green->green, 255, 'green green' );
is( $green->blue,    0, 'green blue' );

is( $green->name, "green", 'green name' );
