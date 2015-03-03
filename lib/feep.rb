require 'wavefile'
require 'os'
require_relative 'feep/constants'

class Feep
  def initialize(options)
    @options = options
    configure_sound(options)
  end
  
  def midi_to_freq(midi_note)
    return 440.0 * (2.0 ** ((midi_note.to_f-69)/12))
  end

  def freq_to_midi(freq)
    return (69 + 12 * (Math.log2(freq.to_i.abs / 440.0))).round
  end

  def configure_sound(options)
    ### A. Check non-essential options
    if !WAVE_TYPES.include?(options[:waveform])
      app_error(ERROR_MSG[:wave_form])
    end

    # Convert ms to secs in order to multiply the sample rate by
    duration_s = (options[:duration].to_f / 1000)

    # Make the samples to write a nice integer
    samples_to_write = (SAMPLE_RATE * duration_s).to_i

    ### B. Set frequency/note, or group of frequencies/notes, to play

    # Is it a chord or a note?
    if options[:freq_or_note].include?(',')
      # yes, it's a chord, so create threads
      threads = []
      options[:freq_or_note].split(',').each do |note|
        sound_to_play = convert_note_to_freq(note)
        output_filename = "#{options[:waveform]}_#{sound_to_play}Hz_#{options[:volume].to_f}_#{options[:duration].to_s}.wav"
        threads << Thread.new {
          play_note(sound_to_play.to_f, options[:waveform], options[:volume].to_f, options[:duration].to_i, samples_to_write, output_filename) 
        }
      end
      threads.each { |th| th.join }
    else
      # no, it's a single note
      sound_to_play = convert_note_to_freq(options[:freq_or_note])
      output_filename = "#{options[:waveform]}_#{sound_to_play}Hz_#{options[:volume].to_f}_#{options[:duration].to_s}.wav"
      play_note(sound_to_play, options[:waveform], options[:volume].to_f, options[:duration].to_i, samples_to_write, output_filename)
    end
  end
  
  def convert_note_to_freq(freq_or_note)
    if freq_or_note.match(/[A-Za-z]/)
      if NOTE_FREQ.has_key?(freq_or_note)
        frequency = NOTE_FREQ[freq_or_note]
      else
        app_error(ERROR_MSG[:note_name])
      end
    else
      frequency = freq_or_note
    end
    
    return frequency
  end

  # plays note using system wav file player
  def play_sound(file, duration)
    delimiter = OS.windows? ? ';' : ':'

    system_apps = ENV['PATH'].split(delimiter).collect {|d| Dir.entries d if Dir.exists? d}.flatten

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
  
  # displays a fun beep message
  def display_text_beep(duration)
    print 'Be'
    1.upto(duration) {|ms|
      if ms % 100 == 0
        print 'e'
      end
    }
    puts 'ep!'
  end
  
  # removes the sound, unless marked to save
  def remove_sound(file)
    if !@options[:save]
      if OS.windows?
        system("del #{file}")
      else
        system("rm #{file}")
      end
    else
      if @options[:loud]
        info = WaveFile::Reader.info(file)
        duration = info.duration
        formatted_duration = duration.minutes.to_s.rjust(2, '0') << ':' <<
                           duration.seconds.to_s.rjust(2, '0') << ':' <<
                           duration.milliseconds.to_s.rjust(3, '0')
        puts ""
        puts "Created #{file}"
        puts "---"
        puts "Length:      #{formatted_duration}"
        puts "Format:      #{info.audio_format}"
        puts "Channels:    #{info.channels}"
        puts "Frames:      #{info.sample_frame_count}"
        puts "Sample Rate: #{info.sample_rate}"
      end
    end
  end
  
  # code from Joel Strait's nanosynth to generate raw audio
  def create_sound(frequency, waveform, samples, volume, output_filename)
    # Generate sample data for the given frequency, amplitude, and duration.
    # Since we are using a sample rate of 44,100Hz, 44,100 samples are required for one second of sound.
    samples = generate_sample_data(waveform.to_sym, samples, frequency.to_f, volume.to_f)

    # Wrap the array of samples in a Buffer, so that it can be written to a Wave file
    # by the WaveFile gem. Since we generated samples between -1.0 and 1.0, the sample
    # type should be :float
    buffer = WaveFile::Buffer.new(samples, WaveFile::Format.new(:mono, :float, 44100))

    # Write the Buffer containing our samples to a 16-bit, monophonic Wave file
    # with a sample rate of 44,100Hz, using the WaveFile gem.
    WaveFile::Writer.new(output_filename, WaveFile::Format.new(:mono, :pcm_16, 44100)) do |writer|
      writer.write(buffer)
    end
  end
  
  # more code from Joel Strait's nanosynth (http://joe)
  # The dark heart of NanoSynth, the part that actually generates the audio data
  def generate_sample_data(wave_type, num_samples, frequency, max_amplitude)
    position_in_period = 0.0
    position_in_period_delta = frequency / SAMPLE_RATE

    # Initialize an array of samples set to 0.0. Each sample will be replaced with
    # an actual value below.
    samples = [].fill(0.0, 0, num_samples)

    num_samples.times do |i|
      # Add next sample to sample list. The sample value is determined by
      # plugging position_in_period into the appropriate wave function.
      if wave_type == :sine
        samples[i] = Math::sin(position_in_period * TWO_PI) * max_amplitude
      elsif wave_type == :square
        samples[i] = (position_in_period >= 0.5) ? max_amplitude : -max_amplitude
      elsif wave_type == :saw
        samples[i] = ((position_in_period * 2.0) - 1.0) * max_amplitude
      elsif wave_type == :triangle
        samples[i] = max_amplitude - (((position_in_period * 2.0) - 1.0) * max_amplitude * 2.0).abs
      elsif wave_type == :noise
        samples[i] = RANDOM_GENERATOR.rand(-max_amplitude..max_amplitude)
      end

      position_in_period += position_in_period_delta
      
      # Constrain the period between 0.0 and 1.0.
      # That is, keep looping and re-looping over the same period.
      if(position_in_period >= 1.0)
        position_in_period -= 1.0
      end
    end
    
    return samples
  end
  
  # creates, plays, and removes note
  def play_note(frequency, waveform, volume, duration, samples_to_write, output_filename)
    if @options[:loud]
      puts 'Playing note'
      puts "  frequency:    #{frequency.to_f.abs}"
      puts "  midi:         #{freq_to_midi(frequency)}"
      puts "  duration:     #{duration}"
    end
    create_sound(frequency, waveform, samples_to_write, volume, output_filename)
    play_sound(output_filename, duration)
    remove_sound(output_filename)
  end

  # displays error, usage, and exits
  def app_error(msg)
    puts "#{File.basename($0).split(".")[0]}: #{msg}"
    puts 'usage: feep [frequency|note_name|list_of_frequencies_or_note_names] [sine|square|saw|triangle|noise] [volume] [duration] [save]'
    exit
  end

end