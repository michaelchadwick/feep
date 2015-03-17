# lib/feep.rb
require_relative 'feep/constants'
require_relative 'feep/scale'
require_relative 'feep/sound_file'
require_relative 'feep/sound_player'
require_relative 'feep/utils'
require 'wavefile'

module Feep
  class Base

    # main entry point
    def initialize(options)
      @options = options
      configure_sound(options)
    end

    # takes CLI options, massages them, and passes them to the
    # sound generation methods
    def configure_sound(options)
      ### A. Check non-essential options
      if !WAVE_TYPES.include?(options[:waveform])
        print_error(ERROR_MSG[:invalid_waveform])
      end

      # Convert ms to secs in order to multiply the sample rate by
      duration_s = (options[:duration].to_f / 1000)

      # Make the samples to write a nice integer
      samples_to_write = (SAMPLE_RATE * duration_s).to_i

      ### B. Set frequency/note, or group of frequencies/notes, to play

      # Is it a chord, scale, or single note?
      if options[:freq_or_note].include?(',')
        # yes, it's a chord, so create threads
        threads = []
        options[:freq_or_note].split(',').each do |note|
          sound_to_play = Utils.new.convert_note_to_freq(note)
          output_filename = "#{options[:waveform]}_#{sound_to_play}Hz_#{options[:volume].to_f}_#{options[:duration]}.wav"
          threads << Thread.new {
            SoundPlayer.new.play_note(sound_to_play, output_filename, samples_to_write, options) 
          }
        end
        threads.each { |th| th.join }
      else
        # it's a scale
        if options[:scale]
          Feep::Scale.new.play_scale(options)
        else
          # no, it's a single note
          sound_to_play = Utils.convert_note_to_freq(options[:freq_or_note])
          output_filename = "#{options[:waveform]}_#{sound_to_play}Hz_#{options[:volume].to_f}_#{options[:duration]}.wav"
          SoundPlayer.new.play_note(sound_to_play, output_filename, samples_to_write, options)
        end
      end
    end

  end
end
