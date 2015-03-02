# Feep

Use the power of Ruby to make your computer [feep](http://dictionary.reference.com/browse/feep) using sweet [WAV-file technology](http://wavefilegem.com) from [Joel Strait](https://github.com/jstrait). Works on both Windows and *nix (including OS X) as it uses the standard WAV format to do its bidding.

_Note:_ In order for the sound-playing magic to work on Windows, you will need [sounder](http://www.elifulkerson.com/projects/commandline-wav-player.php), a free command-line WAV file player on your system and in your path. Mac and *nix uses `afplay`, which should be built-in, but feel free to change either to something you already have or desire to install.

## Usage

Feep doesn't require any parameters, as it will play a 440Hz sine wave at 50% full volume for 1000 milliseconds unless you supply one. Feep will only save the resulting WAV file it creates if you specify the `-save` parameter.

The full usage looks like this:

`feep [frequency|note_name|comma-delimited_frequencies_or_note_names] [waveform] [volume] [duration] [-save]`

**-frequency**: a number from 0 to 20000. You can try something bigger or smaller, but you may get odd results.

**-waveform**: a string equal to "sine", "square", "saw", "triangle", or "noise".

**-volume**: a number from 0.0 (silence (why would you do this?)) to 1.0 (blast it)

**-duration**: number of milliseconds for the sound to last

**-save**: save the resulting WAV file in the current directory. Will create it in the format of "waveform_frequency-in-Hz_volume.wav"