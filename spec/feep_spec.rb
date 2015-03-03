require 'spec_helper'

describe Feep do
  subject { Feep.new }
  
  describe '#play_sound' do
    options = {
      :freq_or_note => '440.000', 
      :waveform => 'sine', 
      :volume => 0.5, 
      :duration => 500, 
      :save => false,
      :loud => false
    }
  
    it 'plays a sound with no options' do
      expect(Feep.new(options)).to eq "sound played"
    end
  end

end
