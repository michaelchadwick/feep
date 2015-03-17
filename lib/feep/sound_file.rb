# lib/feep/sound_file.rb
# Contains code from Joel Strait's nanosynth to generate raw audio

require 'wavefile'
require_relative 'constants'

module Feep
  class SoundFile

    def create_sound(frequency, samples, output_filename, options)
      # Generate sample data for the given frequency, amplitude, and duration.
      # Since we are using a sample rate of 44,100Hz, 44,100 samples are required for one second of sound.
      samples = generate_sample_data(options[:waveform].to_sym, samples, frequency.to_f, options[:volume].to_f)

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

  end
end