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
	name 			=> 'testpattern',
	tempo			=> 'andante',
	time_signature  => '4/4',
	key_signature	=> 'C',
);

my $pattern1 = $testpattern->new_track(
	name 	 => 'pattern1',
);

$pattern1->load_test_pattern();

my $pattern2 = $testpattern->new_track(
	name	=> 'pattern2',
);

$pattern2->_add_sine_wave( 440 , 15, 1 );

$testpattern->mixdown()->save();
