Mandelflow
==========

The perl scripts that calculated and recorded the fractal music on my website.  These are open sourced so you can pick through them and have a look.  If you feel like building off of them, go for it, and feel free to email me with any questions.

Structure
---------

There are three main directories here:

* **songs** is where the actual .wav file outputs are kept
* **script** is where the input perl scripts are kept
* **lib** is for all of the perl modules that do the heavy lifting

**Scripts**

There are a small handful of scripts here.  A few just dump out test patterns, though `mandelflow.pl` and `fibonacci.pl` both output songs you might want to fiddle with.

**Libraries**

There are two major libraries here -- Audio::Wav and Audio::Synthesizer.  Both have large sections that haven't been written yet.  I put together Audio::Wav to quickly read and write Pulse Code Modulated (PCM) data, and Audio::Synthesizer to do the actual temperament, song, tempo, and track calculations.

License
-------

		Copyright (C) 2011 Dann Stayskal

		This program is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program.  If not, see <http://www.gnu.org/licenses/>.

