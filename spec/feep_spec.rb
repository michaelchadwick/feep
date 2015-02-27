require 'spec_helper'

describe Feep do
  subject { Feep.new }
  
  describe '#basic_stuff' do
    it 'has a version number' do
      expect(Feep::VERSION).not_to be nil
    end
  end
  
  describe '#play_sound' do
    options = {
      :freq_or_note => "440.000", 
      :waveform => "sine", 
      :volume => 0.5, 
      :duration => 100, 
      :save => false
    }
    let(:feep) { Feep.new(options) }
  
    it 'plays a sound with no options' do
      expect(:feep).to eq "Beep!"
    end
  end

end
