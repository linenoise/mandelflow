package Audio::Synthesizer::Temperament;

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

use constant MIDDLE_C => 440 * (2 ** -9) ** (1/12);

###
# If you don't know what a temperament is, you probably want 12-TET ("12 tone equal temperament")
# (or "what happens when you didive an octave into twelve logarithmically equal parts")
###

sub new {
	my ($class, $name) = @_;
	my $self = {};
	bless $self, $class;
	return $self->_load_temperament($name);
	return $self;
}


sub _load_temperament {
	my ($self, $name) = @_;
	my $temperaments = {
		'5-TET'  => sub { $self->_load_equal_temperament( octave_divisions => 5 )},  # Some Indonesian gamelans
		'7-TET'  => sub { $self->_load_equal_temperament( octave_divisions => 7 )},  # Ugandan Chopi xylophone
		'12-TET' => sub { $self->_load_equal_temperament( octave_divisions => 12 )}, # Lots of western music
		'23-TET' => sub { $self->_load_equal_temperament( octave_divisions => 23 )}, # Something Emily wanted
		'24-TET' => sub { $self->_load_equal_temperament( octave_divisions => 24 )}, # Microtuning
	};
	
	return $temperaments->{$name}->() if $temperaments->{$name};
	return undef;
}


sub _load_equal_temperament {
	my ($self, %args) = @_;

	### If they don't tell us how many octaves they want mapped, assume 10
	$args{octaves} ||= 9;
	
	### If they don't tell us how many octave divisions they want, assume 12
	$args{octave_divisions} ||= 12;
	
	$self->{notes} ||= [];
	my $nth_in_series = 0;
	my $place_of_middle_c_in_series = 4 * $args{octave_divisions};
	
	foreach my $octave (0..$args{octaves}-1) {
		$self->{notes}->[$octave] ||= [];
		foreach my $division (0..$args{octave_divisions}-1) {
			$self->{notes}->[$octave]->[$division] = 
				MIDDLE_C * (
					2 ** (
						$nth_in_series - $place_of_middle_c_in_series
					)
				) ** (
					1 / $args{octave_divisions}
				);
			$nth_in_series++;
		}
	}
	
	return $self;
}


1;