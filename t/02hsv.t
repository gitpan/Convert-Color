#!/usr/bin/perl

use Test::More tests => 16;

use Convert::Color::HSV;

my $red = Convert::Color::HSV->new( 0, 1, 1 );

is( $red->hue,          0, 'red hue' );
is( $red->saturation,   1, 'red saturation' );
is( $red->value,        1, 'red value' );

is_deeply( [ $red->rgb ], [ 1, 0, 0 ], 'red rgb' );

my $green = Convert::Color::HSV->new( 120, 1, 1 );

is( $green->hue,        120, 'green hue' );
is( $green->saturation,   1, 'green saturation' );
is( $green->value,        1, 'green value' );

is_deeply( [ $green->rgb ], [ 0, 1, 0 ], 'green rgb' );

my $blue = Convert::Color::HSV->new( 240, 1, 1 );

is( $blue->hue,        240, 'blue hue' );
is( $blue->saturation,   1, 'blue saturation' );
is( $blue->value,        1, 'blue value' );

is_deeply( [ $blue->rgb ], [ 0, 0, 1 ], 'blue rgb' );

my $yellow = Convert::Color::HSV->new( '60,1,1' );

is( $yellow->hue,         60, 'yellow hue' );
is( $yellow->saturation,   1, 'yellow saturation' );
is( $yellow->value,        1, 'yellow value' );

is_deeply( [ $yellow->rgb ], [ 1, 1, 0 ], 'yellow rgb' );
