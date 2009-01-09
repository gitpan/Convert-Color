#!/usr/bin/perl

use Test::More tests => 16;

use Convert::Color::HSL;

my $red = Convert::Color::HSL->new( 0, 1, 0.5 );

is( $red->hue,          0, 'red hue' );
is( $red->saturation,   1, 'red saturation' );
is( $red->lightness,  0.5, 'red lightness' );

is_deeply( [ $red->hsl ], [ 0, 1, 0.5 ], 'red hsl' );

my $green = Convert::Color::HSL->new( 120, 1, 0.5 );

is( $green->hue,        120, 'green hue' );
is( $green->saturation,   1, 'green saturation' );
is( $green->lightness,  0.5, 'green lightness' );

is_deeply( [ $green->hsl ], [ 120, 1, 0.5 ], 'green hsl' );

my $blue = Convert::Color::HSL->new( 240, 1, 0.5 );

is( $blue->hue,        240, 'blue hue' );
is( $blue->saturation,   1, 'blue saturation' );
is( $blue->lightness,  0.5, 'blue lightness' );

is_deeply( [ $blue->hsl ], [ 240, 1, 0.5 ], 'blue hsl' );

my $yellow = Convert::Color::HSL->new( '60,1,0.5' );

is( $yellow->hue,         60, 'yellow hue' );
is( $yellow->saturation,   1, 'yellow saturation' );
is( $yellow->lightness,  0.5, 'yellow lightness' );

is_deeply( [ $yellow->hsl ], [ 60, 1, 0.5 ], 'yellow hsl' );
