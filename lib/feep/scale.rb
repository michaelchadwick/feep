# lib/feep/scale.rb

require_relative '../feep'
require_relative 'utils'
require_relative 'constants'

module Feep
  class Scale

    # plays the musical scale with Feep
    def play_scale(options)
      unless SCALES.include?(options[:scale].to_sym)
        Utils.print_error(:invalid_scale)
      end

      valid_notes = NOTES | NOTES_ALT | FREQS
      freq = Utils::convert_note_to_freq(options[:freq_or_note]).to_f

      if valid_notes.include?(freq)
        steps = SCALES[options[:scale].to_sym].split(',')

        freq_index = FREQS.index(freq)

        feep_options = {
          :freq_or_note => freq.to_s, 
          :waveform => options[:waveform], 
          :volume => options[:volume], 
          :duration => options[:duration], 
          :save => options[:save], 
          :verbose => options[:verbose]
        }

        # play number of degrees of scale supplied or one octave by default
        degrees = options[:degrees] || steps.length

        if options[:verbose]
          puts "Playing a #{options[:scale]} scale..."
        end

        1.upto(degrees.to_i) {|deg|
          if options[:verbose]
            puts "note: #{NOTE_FREQ.key(freq)}, freq: #{freq}"
          end
          
          # play note
          Feep::Base.new(feep_options)
      
          # go to the next note in the scale
          freq_index += steps[deg].to_i

          # set new note to play next time around
          freq = feep_options[:freq_or_note] = FREQS[freq_index].to_s
        }
      else
        Utils.print_error(:invalid_scale_root_note)
      end
    end

  end
end