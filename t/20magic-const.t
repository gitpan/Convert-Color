#!/usr/bin/perl

use Test::More tests => 20;

use Convert::Color;

my $red = Convert::Color->new( 'rgb:1,0,0' );

isa_ok( $red, 'Convert::Color::RGB' );

is( $red->red,   1, 'red red' );
is( $red->green, 0, 'red green' );
is( $red->blue,  0, 'red blue' );

$red = Convert::Color->new( 'rgb8:255,0,0' );

isa_ok( $red, 'Convert::Color::RGB8' );

is( $red->red,   255, 'red red' );
is( $red->green,   0, 'red green' );
is( $red->blue,    0, 'red blue' );

$red = Convert::Color->new( 'rgb16:65535,0,0' );

isa_ok( $red, 'Convert::Color::RGB16' );

is( $red->red,   65535, 'red red' );
is( $red->green,     0, 'red green' );
is( $red->blue,      0, 'red blue' );

my $green = Convert::Color->new( 'hsv:120,1,1' );

isa_ok( $green, 'Convert::Color::HSV' );

is( $green->hue,        120, 'green hue' );
is( $green->saturation,   1, 'green saturation' );
is( $green->value,        1, 'green value' );

my $blue = Convert::Color->new( 'hsl:240,1,0.5' );

isa_ok( $blue, 'Convert::Color::HSL' );

is( $blue->hue,        240, 'blue hue' );
is( $blue->saturation,   1, 'blue saturation' );
is( $blue->lightness,  0.5, 'blue lightness' );
