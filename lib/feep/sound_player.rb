require 'os'
require_relative 'sound_file'
require_relative 'constants'

module Feep
  class SoundPlayer
  
    # main function that creates, plays, and removes note
    def play_note(frequency, output_filename, samples_to_write, options)
      if options[:loud]
        puts 'Playing note'
        puts "  frequency:    #{frequency.to_f.abs}"
        puts "  midi:         #{Utils.freq_to_midi(frequency)}"
        puts "  duration:     #{options[:duration]}"
      end
      SoundFile.new.create_sound(frequency, samples_to_write, output_filename, options)
      play_wav_file(output_filename, options[:duration])
      remove_sound(output_filename, options)
    end
  
    # use command line app to play wav file
    def play_wav_file(file, duration)
      delimiter = OS.windows? ? ';' : ':'

      system_apps = ENV['PATH'].split(delimiter).collect { |d| Dir.entries d if Dir.exist? d }.flatten

      if OS.windows?
        if system_apps.include? SNDPLAYER_WIN
          display_text_beep(duration)
          system("#{SNDPLAYER_WIN} #{file}")
        else
          puts "couldn't find #{SNDPLAYER_WIN}"
        end
      end

      if OS.mac? || OS.linux?
        if system_apps.include? SNDPLAYER_UNIX
          display_text_beep(duration)
          system("#{SNDPLAYER_UNIX} #{file}")
        else
          puts "couldn't find #{SNDPLAYER_UNIX}"
        end
      end
    end
    
    # displays a fun beep message after playing wav file
    def display_text_beep(duration)
      print 'Be'
      1.upto(duration) {|ms|
        if ms % 100 == 0
          print 'e'
        end
      }
      puts 'ep!'
    end

    # removes the sound, unless marked to save, 
    # and optionally display info about file
    def remove_sound(file, options)
      unless options[:save]
        if OS.windows?
          system("del #{file}")
        else
          system("rm #{file}")
        end
      else
        if options[:loud]
          info = WaveFile::Reader.info(file)
          duration = info.duration
          formatted_duration = duration.minutes.to_s.rjust(2, '0') << ':' <<
                             duration.seconds.to_s.rjust(2, '0') << ':' <<
                             duration.milliseconds.to_s.rjust(3, '0')
          puts ''
          puts "Created #{file}"
          puts '---'
          puts "Length:      #{formatted_duration}"
          puts "Format:      #{info.audio_format}"
          puts "Channels:    #{info.channels}"
          puts "Frames:      #{info.sample_frame_count}"
          puts "Sample Rate: #{info.sample_rate}"
        end
      end
    end

  end
end