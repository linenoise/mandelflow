package Audio::Synthesizer::Song;

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

use constant PI => 4 * atan2(1, 1);

use Audio::Synthesizer::Tempo;
use Audio::Synthesizer::Track;


### Instantiator

sub new {
	my ($class, %args) = @_;
	my $self = {%args};
	bless $self, $class;
	
	meminfo('song_creation');
	
	### Let 'em know how we roll
	print "Creating song $self->{name}\n";

	### Set the initial song attributes if they provided them
	$self->tempo($args{tempo}) if $args{tempo};
	$self->time_signature($args{time_signature}) if $args{time_signature};
	$self->key_signature($args{key_signature}) if $args{key_signature};

	$self->{pcm_data} = '';
	$self->{tracks} = [];
	
	return $self;
}


### Accessor methods

sub time_signature {
	my ($self,$time_signature) = @_;
	if ($time_signature) {
		$self->{time_signature} = $time_signature;
		print "   - song $self->{name} setting time signature to $time_signature\n";
		return $self;
	} else {
		return $self->{time_signature};
	}
}

sub key_signature {
	my ($self,$key_signature) = @_;
	if ($key_signature) {
		$self->{key_signature} = $key_signature;
		print "   - song $self->{name} setting key to $key_signature\n";
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
			print "   - song $self->{name} setting tempo to $tempo BPM\n";
		} else {
			### If they said something like 'allegretto grazioso ma non troppo' instead of '108'
			my $bpm = Audio::Synthesizer::Tempo::lookup_tempo($tempo);
			$self->{tempo} = $bpm;
			print "   - song $self->{name} setting tempo to $tempo ($bpm BPM)\n";
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
		print "   - song $self->{name} setting temperament to $temperament\n";
		return $self;
	} else {
		return $self->{temperament};
	}
}


### Track management methods

sub new_track {
	my ($self, %args) = @_;
	meminfo("creating track $args{name}");
	
	my $track = new Audio::Synthesizer::Track (%args, 
		bits_sample    => $self->{bits_sample},
		sample_rate    => $self->{sample_rate},
		time_signature => $self->{time_signature},
		key_signature  => $self->{key_signature},
		tempo		   => $self->{tempo},
		temperament    => $self->{temperament},
		name		   => $args{name},
	);
	push @{$self->{tracks}}, $track;
	return $track;
}

sub meminfo {
	my ($marker) = @_;
	my $memory = `ps axl | grep perl | sed '/grep/d' | awk '{print \$8}'`;
	chomp $memory;
	$memory /= 1024;
	print "      - At marker $marker, perl is using $memory Mb of memory\n";
}


### File I/O methods

sub mixdown {
	my ($self, %args) = @_;
	
	### If we only have one track, "mixdown" is cake!
	if (scalar(@{$self->{tracks}}) == 1) {
		$self->{pcm_data} = $self->{tracks}->[0]->{pcm_data};
		return $self;
	}
	
	print "Mixing down tracks\n";
	
	meminfo('before_mixdown');
	my $mixdown_length = 0;
	my $mixdown_samples = 0;
	foreach my $track (@{$self->{tracks}}) {
		my $track_length = length($track->{pcm_data});
		print "   - $track->{name} has $track_length bytes of PCM\n";
		if ($track_length > $mixdown_length) {
			$mixdown_length = $track_length;
		}
	}
	$mixdown_samples = int($mixdown_length) / 2;
	print "   - Mixdown length: $mixdown_length bytes ($mixdown_samples samples) \n";
	
	my $index = 0;
	my $max_amplitude = ( 2 ** $self->{bits_sample} ) / 2;
	foreach my $sample_index (0..$mixdown_samples-1) {
		my $sample = 0;
		foreach my $track (@{$self->{tracks}}) {
			if ($sample_index < length($track->{pcm_data})/2) {
				$sample += unpack('s*',substr($track->{pcm_data},$sample_index*2, 2)) / scalar(@{$self->{tracks}});
			}
		}
		$self->{pcm_data} .= pack('v*',$sample);
	}
	meminfo('after_mixdown');
	return $self;
}

sub save {
	my ($self, %args) = @_;
	
	### Spin up the PCM handler and the initial scribe
	my $file_name = "songs/$self->{name}.wav";
	print "\nSaving song to $file_name\n";
	my $pcm_handler = new Audio::Wav;
	my $writer = $pcm_handler->write( 
		$file_name, {
			'bits_sample'   => $self->{bits_sample},
			'sample_rate'   => $self->{sample_rate},
			'channels'      => 1,
			#'no_cache'     => 1,
		}
	);

	### Dump the current PCM buffer
	print "   - PCM Buffer:  ".length($self->{pcm_data}). " bytes\n";
	$writer->write_raw( $self->{pcm_data} );
	$writer->finish();

	print "\nDone.\n";
	return $self;
}

sub play {
	my ($self) = @_;
	print "Playing $self->{file_name}\n";
	system("/usr/bin/afplay $self->{file_name}");
	return $self;
}

1;