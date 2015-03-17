# Feep
[![Gem Version](https://badge.fury.io/rb/feep.svg)](http://badge.fury.io/rb/feep)

## Wha?
Use the power of Ruby gems to make your computer [feep](http://dictionary.reference.com/browse/feep) (except more musically) using sweet [WAV-file-writing technology](http://wavefilegem.com) from [Joel Strait](https://github.com/jstrait). Works on both Windows and *nix (including OS X) as it uses the standard WAV format to do its bidding.

_Note:_ In order for the sound-playing magic to work on Windows, you will need [sounder](http://www.elifulkerson.com/projects/commandline-wav-player.php), a free command-line WAV file player on your system and in your path. Mac and *nix uses `afplay`, which should be built-in, but feel free to change either to something you already have or desire to install.

## Why?

Besides a quick way to make some kind of noise for fun or testing your speakers, which I always appreciate, `feep` could be used to tie into another Ruby script for an alert tone or maybe even some wicked cool command-line game that needs musical note sound effects. The opportunities are essentially endless.

## How?

* `gem install feep`

Feep doesn't require any parameters, as it will play a 440Hz/A4 sine wave at 50% full volume for 200 milliseconds unless you supply one of the below options. Feep will only save the resulting WAV file it creates if you specify the `-save` parameter.

The full usage looks like this:

`feep [-f, -n, --freq-or-note FREQUENCY|NOTE_NAME] [-s, --scale SCALE_ID] [-d, --degrees NUMBER_OF_SCALE_DEGREES] [-w, --waveform WAVEFORM] [-a, --amplitude MAX_AMPLITUDE] [-d, --duration DURATION] [-save] [-loud]`

`-f, -n, --freq-or-note`: a number from 0 to 20000, or a valid note name from C0 to B9 (including sharps and flats). You can try a frequency outside of this range, but you may get odd results. You may also enter some combination of these with commas between them and it'll play all of them together in a chord.

`-s, -scale`: a scale ID that is part of the list that the gem understands (currently). If you put in an invalid one, it will list the valid ones.

`-d, --degrees`: the number of degrees of a scale you want to play. By default, the scale will play one octave.

`-w, --waveform`: a string equal to "sine", "square", "saw", "triangle", or "noise".

`-a, --amplitude`: a number from 0.0 (silence (why would you do this?)) to 1.0 (blast it).

`-d, --duration`: number of milliseconds for the sound to last.

`-save`: switch to save the resulting WAV file in the current directory. Will create it in the format of `waveform_frequency-in-Hz_volume_duration.wav`.

`-loud`: switch that displays note and file-making information.

## Examples

* `feep` - play a C4 sine wave note at 50% full volume for 200 ms
* `feep -n Ab6 -w saw` - play a Ab6 sawtooth wave note at 50% full volume for 200 ms
* `feep -n C#5 -w square -a 0.4 -d 500` - play a C#5 square wave note at 40% full volume for 500 ms
* `feep -n 2000 -w triangle -a 0.8 -d 2000` - play a 2000Hz triangle wave note at 80% full volume for 2000 ms
* `feep -n C3 -s major` - play a major scale with C3 as the root note
