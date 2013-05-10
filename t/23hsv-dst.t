#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use Convert::Color::HSV;

my $black = Convert::Color::HSV->new(   0, 1, 0 );
my $white = Convert::Color::HSV->new(   0, 0, 1 );
my $red   = Convert::Color::HSV->new(   0, 1, 1 );
my $green = Convert::Color::HSV->new( 120, 1, 1 );
my $cyan  = Convert::Color::HSV->new( 180, 1, 1 );
my $blue  = Convert::Color::HSV->new( 240, 1, 1 );

sub about
{
   my ( $got, $expect, $name ) = @_;

   ok( abs( $got - $expect ) < 0.000001, $name ) or
      diag( "got $got, expected $expect" );
}

is( $black->dst_hsv( $black ), 0, 'black->dst_hsv black' );

about( $black->dst_hsv( $red   ), 1/sqrt(2), 'black->dst_hsv red' );
about( $black->dst_hsv( $green ), 1/sqrt(2), 'black->dst_hsv green' );
about( $black->dst_hsv( $blue  ), 1/sqrt(2), 'black->dst_hsv blue' );

about( $black->dst_hsv( $white ), 1/2, 'black->dst_hsv white' );

is( $red->dst_hsv( $cyan ), 1, 'red->dst_hsv cyan' );

is( $black->dst_hsv_cheap( $black ), 0, 'black->dst_hsv_cheap black' );

is( $black->dst_hsv_cheap( $red   ), 2, 'black->dst_hsv_cheap red' );
is( $black->dst_hsv_cheap( $green ), 2, 'black->dst_hsv_cheap green' );
is( $black->dst_hsv_cheap( $blue  ), 2, 'black->dst_hsv_cheap blue' );

is( $black->dst_hsv_cheap( $white ), 1, 'black->dst_hsv_cheap white' );

is( $red->dst_hsv_cheap( $cyan ), 4, 'red->dst_hsv_cheap cyan' );

done_testing;
