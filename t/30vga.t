#!/usr/bin/perl

use Test::More tests => 14;

use Convert::Color::VGA;

my $red = Convert::Color::VGA->new( 'red' );

is( $red->red,   1, 'red red' );
is( $red->green, 0, 'red green' );
is( $red->blue,  0, 'red blue' );

is( $red->name,  "red", 'red name' );
is( $red->index, 4,     'red index' );

is_deeply( [ $red->as_rgb8->rgb8 ], [ 255, 0, 0 ], 'red as_rgb8' );

my $green = Convert::Color::VGA->new( 2 );

is( $green->red,   0, 'green red' );
is( $green->green, 1, 'green green' );
is( $green->blue,  0, 'green blue' );

is( $green->name,  "green", 'green name' );
is( $green->index, 2,       'green index' );

my $blue = Convert::Color->new( 'vga:blue' );

is( $blue->red,   0, 'blue red' );
is( $blue->green, 0, 'blue green' );
is( $blue->blue,  1, 'blue blue' );
