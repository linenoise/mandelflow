package Audio::Synthesizer;

###
#  Copyright (C) 2011 Danne Stayskal
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


use Audio::Wav;

use Audio::Synthesizer::Song;
use Audio::Synthesizer::Temperament;

sub new {
	my ($class, %args) = @_;
	my $self = {%args};
	bless $self, $class;
	
	### Let 'em know how we roll
	print "Initializing synthesizer at $self->{sample_rate}Hz, $self->{bits_sample} bits\n";

	### Set the temperament (and assume 12-TET if they didn't say otherwise)
	if ($args{temperament}) {
		$self->temperament($args{temperament});
	} else {
		$self->temperament('12-TET');
	}

	$self->{songs} = [];

	return $self;
}


sub temperament {
	my ($self,$temperament) = @_;
	if ($temperament) {
		delete($self->{temperament}) if $self->{temperament};
		$self->{temperament} = new Audio::Synthesizer::Temperament($temperament);
		print "   - synth setting temperament to $temperament\n";
		foreach my $song (@{$self->{songs}}) {
			$song->temperament($self->{temperament});
		}
		return $self;
	} else {
		return $self->{temperament};
	}
}


sub new_song {
	my ($self, %args) = @_;
	my $song = new Audio::Synthesizer::Song (%args, 
		bits_sample => $self->{bits_sample},
		sample_rate => $self->{sample_rate},
		temperament => $self->{temperament},
	);
	push @{$self->{songs}}, $song;
	return $song;
}

1;