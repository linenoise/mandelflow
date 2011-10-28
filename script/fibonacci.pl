#!/usr/bin/perl -w
use strict;
use lib qw(lib);
use Audio::Synthesizer;

my $synthesizer = new Audio::Synthesizer(
	temperament 	=> '5-TET',
	sample_rate 	=> 44100,
	bits_sample 	=> 16,	
);

my $mandelflow = $synthesizer->new_song(
	name 			=> 'fibonacci',
	tempo			=> 'andante',
	time_signature  => '4/4',
	key_signature	=> 'C',
);

my $penultimate = 1;
my $current = 1;
foreach (0..100) {
	print( ($current % 5)." - $current \n");
	$mandelflow->_add_sine_wave( $synthesizer->{temperament}->{notes}->[4]->[$current % 5] , 0.5, 1 );
	my $oldpenult = $penultimate;
	$penultimate = $current;
	$current = $current + $oldpenult;
}

$mandelflow->save();
