#!/usr/bin/perl -w
use strict;
use lib qw(lib);
use Audio::Synthesizer;

my $synthesizer = new Audio::Synthesizer(
	temperament 	=> '12-TET',
	sample_rate 	=> 44100,
	bits_sample 	=> 16,	
);

my $mandelflow = $synthesizer->new_song(
	name 			=> 'tribonacci',
	tempo			=> 'andante',
	time_signature  => '4/4',
	key_signature	=> 'C',
);

my $antepenultimate = 1;
my $penultimate = 1;
my $current = 1;
foreach (0..100) {
	print( ($current % 7)." - $current \n");
	$mandelflow->_add_sine_wave( $synthesizer->{temperament}->{notes}->[4]->[$current % 7] , 0.1, 1 );
	my $oldpenult = $penultimate;
	my $oldante = $antepenultimate;
	
	$antepenultimate = $penultimate;
	$penultimate = $current;
	$current = $current + $oldpenult + $oldante;
}

$mandelflow->save();
