# lib/feep/utils.rb
module Feep
  module Utils

    # convert midi notes to frequencies
    def self.midi_to_freq(midi_note)
      440.0 * (2.0 ** ((midi_note.to_f-69)/12))
    end

    # convert frequencies to midi notes
    def self.freq_to_midi(freq)
      (69 + 12 * (Math.log2(freq.to_i.abs / 440.0))).round
    end

    # makes sure that whatever kind of sound was entered on the CLI
    # it is now a frequency to feed into the sample data generator
    def self.convert_note_to_freq(freq_or_note)
      if freq_or_note.match(/[A-Za-z]/)
        if NOTE_FREQ.key?(freq_or_note)
          frequency = NOTE_FREQ[freq_or_note]
        else
          print_error(ERROR_MSG[:invalid_note])
        end
      else
        frequency = freq_or_note
      end
      
      return frequency
    end
    
    # displays error, usage, and exits
    def self.print_error(msg_id)
      msg = ERROR_MSG[msg_id.to_sym]
      puts "#{File.basename($PROGRAM_NAME).split(".")[0]}: #{msg}"
      puts 'usage: feep [frequency|note-name|list-of-frequencies-or-note-names] [scale] [scale-degrees] [sine|square|saw|triangle|noise] [volume] [duration] [save] [loud]'
      exit
    end
  
  end
end