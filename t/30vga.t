#!/usr/bin/perl

use Test::More tests => 9;

use Convert::Color::VGA;

my $red = Convert::Color::VGA->new( 'red' );

is( $red->red,   1, 'red red' );
is( $red->green, 0, 'red green' );
is( $red->blue,  0, 'red blue' );

my $green = Convert::Color::VGA->new( 2 );

is( $green->red,   0, 'green red' );
is( $green->green, 1, 'green green' );
is( $green->blue,  0, 'green blue' );

my $blue = Convert::Color->new( 'vga:blue' );

is( $blue->red,   0, 'blue red' );
is( $blue->green, 0, 'blue green' );
is( $blue->blue,  1, 'blue blue' );
