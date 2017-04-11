require 'spec_helper'

describe Feep do
  
  describe '#play_sound' do
    options = {
      :freq_or_note => '440.000', 
      :scale => nil, 
      :waveform => 'sine', 
      :volume => 0.5, 
      :duration => 100, 
      :save => false, 
      :verbose => false, 
      :usage => nil
    }
  
    it 'plays a sound with no options' do
      expect(Feep.new(options)).to eq "sound played"
    end
  end

end
