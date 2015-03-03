# Feep

## Wha?
Use the power of Ruby gems to make your computer [feep](http://dictionary.reference.com/browse/feep) (except more musically) using sweet [WAV-file-writing technology](http://wavefilegem.com) from [Joel Strait](https://github.com/jstrait). Works on both Windows and *nix (including OS X) as it uses the standard WAV format to do its bidding.

_Note:_ In order for the sound-playing magic to work on Windows, you will need [sounder](http://www.elifulkerson.com/projects/commandline-wav-player.php), a free command-line WAV file player on your system and in your path. Mac and *nix uses `afplay`, which should be built-in, but feel free to change either to something you already have or desire to install.

## Why?

Besides a quick way to make some kind of noise, which I always appreciate, this could be used to tie into another Ruby script for an alert tone or maybe even some wicked cool command-line game that needs musical note sound effects. The opportunities are essentially endless.

## How?

Feep doesn't require any parameters, as it will play a 440Hz/A4 sine wave at 50% full volume for 1000 milliseconds unless you supply one of the below options. Feep will only save the resulting WAV file it creates if you specify the `-save` parameter.

The full usage looks like this:

`feep [-fn frequency|note_name|comma-delimited_frequencies_or_note_names] [-w waveform] [-v volume] [-d duration] [-save] [-loud]`

`-frequency|note_name|commad-delimted_frequences_or_note_names`: a number from 0 to 20000. You can try something bigger or smaller, but you may get odd results. You may also enter any note name from C0 to B9 (or even flats and sharps like C#6 or Eb5). You may also also enter some combination of these with commas between them and it'll play all of them together in a chord.

`-waveform`: a string equal to "sine", "square", "saw", "triangle", or "noise".

`-volume`: a number from 0.0 (silence (why would you do this?)) to 1.0 (blast it)

`-duration`: number of milliseconds for the sound to last

`-save`: save the resulting WAV file in the current directory. Will create it in the format of `waveform_frequency-in-Hz_volume_duration.wav`

`-loud`: displays note and file-making information