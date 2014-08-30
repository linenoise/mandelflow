package Audio::Synthesizer::Track;

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

use strict;
use constant PI => 4 * atan2(1, 1);

use Audio::Synthesizer::Tempo;
use Audio::Synthesizer::Track;


### Instantiator

sub new {
	my ($class, %args) = @_;
	my $self = {%args};
	bless $self, $class;
	
	### Let 'em know how we roll
	print "Initializing track $self->{name}\n\n";

	### Set the initial tonality if they gave us one
	$self->tonality($args{tonality}) if $args{tonality};
	
	$self->{pcm_data} = '';
	
	return $self;
}


### Accessor methods

sub time_signature {
	my ($self,$time_signature) = @_;
	if ($time_signature) {
		$self->{time_signature} = $time_signature;
		print "   - setting time signature to $time_signature\n";
		return $self;
	} else {
		return $self->{time_signature};
	}
}

sub key_signature {
	my ($self,$key_signature) = @_;
	if ($key_signature) {
		$self->{key_signature} = $key_signature;
		print "   - setting key to $key_signature\n";
		return $self;
	} else {
		return $self->{key_signature};
	}
}

sub tempo {
	my ($self,$tempo) = @_;
	if ($tempo) {
		if($tempo =~ /^\d+$/) {
			### If they just gave us beats per minute
			$self->{tempo} = $tempo;
			print "   - setting tempo to $tempo BPM\n";
		} else {
			### If they said something like 'allegretto grazioso ma non troppo' instead of '108'
			my $bpm = Audio::Synthesizer::Tempo::lookup_tempo($tempo);
			$self->{tempo} = $bpm;
			print "   - setting tempo to $tempo ($bpm BPM)\n";
		}
		return $self;
	} else {
		return $self->{tempo};
	}
}

sub temperament {
	my ($self,$temperament) = @_;
	if ($temperament) {
		delete($self->{temperament}) if $self->{temperament};
		$self->{temperament} = new Audio::Synthesizer::Temperament($temperament);
		print "   - setting temperament to $temperament\n";
		return $self;
	} else {
		return $self->{temperament};
	}
}






### Test Pattern

sub load_test_pattern {
	my ($self) = @_;
	print "Loading test pattern (the note A (440Hz) fading in for one second ".
		  "followed by every note in temperament played for 0.05 seconds)\n";
	foreach my $intensity_coefficient (0..39) {
		my $intensity = 1/(40-$intensity_coefficient);
		$self->_add_sine_wave( 440, 0.1, $intensity );
	}

	foreach my $octave (@{$self->{temperament}->{notes}}) {
		foreach my $frequency (@$octave) {
			$self->_add_sine_wave( $frequency, 0.1, 0.5 );
		}
	}
	return $self;
}


### Private Methods

### Frequency measured in Hertz, Duration in seconds, Intensity on a scale of zero to one
sub _add_sine_wave {
	my ($self, $frequency, $duration, $intensity) = @_;

	my $max_amplitude =  ( 2 ** $self->{bits_sample} ) / 2;
	
	### They SAY they want exactly one second of 440 Hz, but they probably don't want us to
	### simply chop off the waveform in the middle of a peak, do they?  So, we'll give them
	### 1.00014 seconds of 440Hz if they ask for 1.00000 seconds but 1.00014 is the soonest
	### we can stop dumping sine without chopping it off in the prime of the waveform life.
	my $period = 1/$frequency;
	my $adjusted_duration = int($duration/$period)*$period;
	$self->{pcm_data} .= pack('v*', 0); ### Start the sinusoid at zero (offset notwithstanding)
	my $sample_count = $self->{sample_rate} * $adjusted_duration;
	for (my $position = 0; $position < $sample_count; $position++) {
		my $sample = $intensity * $max_amplitude * sin((2 * PI) * 
					 ($position / $self->{sample_rate}) * $frequency);
		$self->{pcm_data} .= pack('v*', $sample);
	}

	return $self;
}


1;