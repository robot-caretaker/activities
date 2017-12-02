require 'rails_helper'

describe LocationLookup do

  let(:lon) { 0.0 }

  subject { described_class.new(lat, lon) }

  context 'with coordinate in a field' do
    let(:lat) { 0.0 }

    it 'returns field' do
      expect(subject.location_type).to eq :field
    end
  end

  context 'with coordinate on a road' do
    let(:lat) { -0.1 }

    it 'returns road' do
      expect(subject.location_type).to eq :road
    end
  end

end
