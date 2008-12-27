#!/usr/bin/perl

use Test::More tests => 33;

use Convert::Color::RGB;

my $red = Convert::Color::RGB->new( 1, 0, 0 );

my $red_rgb8 = $red->as_rgb8;
is( $red_rgb8->red,   255, 'red RGB8 red' );
is( $red_rgb8->green,   0, 'red RGB8 green' );
is( $red_rgb8->blue,    0, 'red RGB8 blue' );

my $red_hsv = $red->as_hsv;
is( $red_hsv->hue,          0, 'red HSV hue' );
is( $red_hsv->saturation,   1, 'red HSV saturation' );
is( $red_hsv->value,        1, 'red HSV value' );

my $red_hsl = $red->as_hsl;
is( $red_hsl->hue,          0, 'red HSL hue' );
is( $red_hsl->saturation,   1, 'red HSL saturation' );
is( $red_hsl->lightness,  0.5, 'red HSL lightness' );

my $green = Convert::Color::RGB->new( 0, 1, 0 );

my $green_hsv = $green->as_hsv;
is( $green_hsv->hue,        120, 'green HSV hue' );
is( $green_hsv->saturation,   1, 'green HSV saturation' );
is( $green_hsv->value,        1, 'green HSV value' );

my $green_hsl = $green->as_hsl;
is( $green_hsl->hue,        120, 'green HSL hue' );
is( $green_hsl->saturation,   1, 'green HSL saturation' );
is( $green_hsl->lightness,  0.5, 'green HSL lightness' );

my $blue = Convert::Color::RGB->new( 0, 0, 1 );

my $blue_hsv = $blue->as_hsv;
is( $blue_hsv->hue,        240, 'blue HSV hue' );
is( $blue_hsv->saturation,   1, 'blue HSV saturation' );
is( $blue_hsv->value,        1, 'blue HSV value' );

my $blue_hsl = $blue->as_hsl;
is( $blue_hsl->hue,        240, 'blue HSL hue' );
is( $blue_hsl->saturation,   1, 'blue HSL saturation' );
is( $blue_hsl->lightness,  0.5, 'blue HSL lightness' );

my $white = Convert::Color::RGB->new( 1, 1, 1 );

my $white_hsv = $white->as_hsv;
is( $white_hsv->hue,          0, 'white HSV hue' );
is( $white_hsv->saturation,   0, 'white HSV saturation' );
is( $white_hsv->value,        1, 'white HSV value' );

my $white_hsl = $white->as_hsl;
is( $white_hsl->hue,          0, 'white HSL hue' );
is( $white_hsl->saturation,   0, 'white HSL saturation' );
is( $white_hsl->lightness,    1, 'white HSL lightness' );

my $black = Convert::Color::RGB->new( 0, 0, 0 );

my $black_hsv = $black->as_hsv;
is( $black_hsv->hue,          0, 'black HSV hue' );
is( $black_hsv->saturation,   0, 'black HSV saturation' );
is( $black_hsv->value,        0, 'black HSV value' );

my $black_hsl = $black->as_hsl;
is( $black_hsl->hue,          0, 'black HSL hue' );
is( $black_hsl->saturation,   0, 'black HSL saturation' );
is( $black_hsl->lightness,    0, 'black HSL lightness' );
