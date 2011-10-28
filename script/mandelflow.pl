#!/usr/bin/perl -w
use strict;
use lib qw(lib);
use Audio::Synthesizer;

$|=1;

my $synthesizer = new Audio::Synthesizer(
	temperament 	=> '12-TET',
	sample_rate 	=> 44100,
	bits_sample 	=> 16,	
);

my $mandelflow = $synthesizer->new_song(
	name 			=> 'mandelflow',
	tempo			=> 'andante',
	time_signature  => '4/4',
	key_signature	=> 'C',
);

my $drone1 = $mandelflow->new_track( name => 'drone1', );
$drone1->_add_sine_wave( 65.41 ,197, 0.08 );

my $drone2 = $mandelflow->new_track( name => 'drone2', );
$drone2->_add_sine_wave( 130.81 ,205, 0.06 );

my $drone3 = $mandelflow->new_track( name => 'drone3', );
$drone3->_add_sine_wave( 196.00 ,200, 0.04 );

my $lead = $mandelflow->new_track(
	name 	 => 'lead',
);


my $Cols=80;
my $Lines=25;

my @chars = reverse(' ','.','-','~','=',':','+','O','%','@','#',' ','.','-','~','=',':','+','O','%','@','#');
my @frequencies = ();
foreach my $octave (4..5) {
	foreach my $note (@{$synthesizer->{temperament}->{notes}->[$octave]}) {
		push @frequencies, $note;
	}
}

my $MaxIter=scalar(@chars)-1;
my $MinRe=-2.0;
my $MaxRe=1.0;
my $MinIm=-1.0;
my $MaxIm=1.0;

for (my $Im=$MinIm; $Im<=$MaxIm; $Im+=($MaxIm-$MinIm)/$Lines) {
	for (my $Re=$MinRe; $Re<=$MaxRe; $Re+=($MaxRe-$MinRe)/$Cols) {
		my $zr=$Re; 
		my $zi=$Im;
		my $n = 0;
		for ($n=0;$n<$MaxIter;$n++) {
			$a=$zr*$zr; $b=$zi*$zi;
			last if $a + $b > 4.0;
			$zi=2*$zr*$zi+$Im; $zr=$a-$b+$Re;
		}
		print $chars[$n];
		$lead->_add_sine_wave( $frequencies[$n] , 0.1, 0.1 );
	}
	print "\n";
}

$mandelflow->mixdown()->save();
