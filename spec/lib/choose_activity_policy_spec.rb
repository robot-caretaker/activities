require 'rails_helper'

describe ChooseActivityPolicy do

  subject { described_class.new(speed, location_type) }

  context 'on a road' do
    let(:location_type) { :road }

    context 'at speed' do
      let(:speed) { 5.1 }
      it 'returns driving' do
        expect(subject.activity).to eq :driving
      end
    end

    context 'low/no speed' do
      let(:speed) { 5.0 }
      it 'returns slacking_off' do
        expect(subject.activity).to eq :slacking_off
      end
    end
  end

  context 'on a field' do
    let(:location_type) { :field }

    context 'moving' do
      let(:speed) { 1.1 }
      it 'returns cultivating' do
        expect(subject.activity).to eq :cultivating
      end
    end

    context 'at a standstill' do
      let(:speed) { 1.0 }
      it 'returns repairing' do
        expect(subject.activity).to eq :repairing
      end
    end
  end

  context 'other' do
    let(:location_type) { :other }
    let(:speed) { 0.0 }
    it 'returns AWOL no matter the speed' do
      expect(subject.activity).to eq :awol
    end
  end

end
