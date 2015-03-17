# lib/feep/scale.rb
require_relative '../feep'
require_relative 'constants'

module Feep
  class Scale

    # plays the musical scale with Feep
    def play_scale(options)
      unless SCALES.include?(options[:scale].to_sym)
        Utils.print_error(:invalid_scale)
      end

      unless NOTES.include?(options[:freq_or_note]) && NOTES_ALT.include?(options[:freq_or_note])
        Utils.print_error(:invalid_note)
      end

      steps = SCALES[options[:scale].to_sym].split(',')

      note = options[:freq_or_note]
      note_index = NOTES.index(note)
      freq = FREQS[NOTES.index(note)]

      feep_options = {:freq_or_note => note, :waveform => options[:waveform], :volume => options[:volume], :duration => options[:duration], :save => options[:save], :loud => options[:loud]}

      # play number of degrees of scale supplied or one octave by default
      degrees = options[:degrees] || steps.length

      if options[:loud]
        puts "Playing a #{options[:scale]} scale..."
      end

      1.upto(degrees.to_i) {|deg|
        if options[:loud]
          puts "note: #{note}, freq: #{freq}"
        end
        
        # play note
        Feep::Base.new(feep_options)

        # go to the next note in the scale
        note_index += steps[deg].to_i

        # set new note to play next time around
        note = feep_options[:freq_or_note] = NOTES[note_index]
        freq = FREQS[note_index]
      }
    end

  end
end