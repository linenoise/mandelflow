package Audio::Synthesizer::Tempo;

###
#  Copyright (C) 2011 Dann Stayskal
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
###

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(lookup_tempo);

sub lookup_tempo {
	my ($tempo) = @_;

	my $modifiers = {
		'con moto' => 5,
		'ma non troppo' => -5,
	};

	my $tempos = {
		'prestissimo'			 => 208, ### extremely fast (more than 200bpm)
		'vivacissimamente'		 => 198, ### adverb of vivacissimo, "very quickly and lively"
		'vivacissimo'			 => 192, ### very fast and lively
		'presto'				 => 184, ### very fast (168–200 bpm)
		'allegrissimo'			 => 170, ### very fast
		'vivo'					 => 160, ### lively and fast
		'vivace'				 => 140, ### lively and fast (≈140 bpm)
		'allegro'				 => 130, ### fast and bright or "march tempo" (120–168 bpm)
		'allegro moderato'		 => 120, ### moderately quick (112–124 bpm)
		'allegretto'			 => 116, ### moderately fast (but less so than allegro)
		'allegretto grazioso' 	 => 113, ### moderately fast and gracefully
		'moderato' 				 => 110, ### moderately (108–120 bpm)
		'moderato espressivo'	 => 100, ### moderately with expression
		'andantino'				 => 97,  ### alternatively faster or slower than andante
		'andante moderato'		 => 95,  ### a bit faster than andante
		'andante'				 => 90,  ### at a walking pace (76–108 bpm)
		'mosey'					 => 80,  ### for all the Texans in the house
		'tranquillamente'		 => 76,  ### adverb of tranquillo, "tranquilly"
		'tranquillo'			 => 73,  ### tranquil
		'adagietto'				 => 70,  ### rather slow (70–80 bpm)
		'adagio'				 => 65,  ### slow and stately (literally, "at ease") (66–76 bpm)
		'larghetto'				 => 60,  ### rather broadly (60–66 bpm)
		'grave'					 => 55,  ### slow and solemn
		'lento'					 => 50,  ### very slow (40–60 bpm)
		'lento moderato'		 => 45,  ### moderately slow
		'largo'					 => 40,  ### very slow (40–60 bpm), like lento
		'larghissimo'			 => 20,  ### very, very slow (20 bpm and below)
		'largamente'			 => 10,  ### very, very, very slow 10bpm
	};
	
	my $delta = 0;
	foreach my $modifier (keys(%{$modifiers})) {
		if(lc($tempo) =~ /$modifier/){
			$delta += $modifiers->{$modifier};
			$tempo =~ s/ $modifier//g;
		}
	}
	
	if ($tempos->{$tempo}) {
		$tempos->{lc($tempo)} + $delta
	} else {
		return undef();
	}

}

1;