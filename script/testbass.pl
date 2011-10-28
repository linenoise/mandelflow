#!/usr/bin/perl -w
use strict;
use lib qw(lib);
use Audio::Synthesizer;

my $synthesizer = new Audio::Synthesizer(
	temperament 	=> '12-TET',
	sample_rate 	=> 44100,
	bits_sample 	=> 16,	
);

my $testpattern = $synthesizer->new_song(
	name 			=> 'testbass',
	tempo			=> 'andante',
	time_signature  => '4/4',
	key_signature	=> 'C',
);

my $pattern1 = $testpattern->new_track(
	name 	 => 'pattern1',
);

$pattern1->_add_sine_wave( 13.75 , 10, 1 );

$testpattern->mixdown()->save();
