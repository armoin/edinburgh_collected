require 'rails_helper'

describe Area do
  describe "validation" do
    before :each do
      subject.valid?
    end

    it "needs a name" do
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it "needs a city" do
      expect(subject.errors[:city]).to include("can't be blank")
    end

    it "needs a country" do
      expect(subject.errors[:country]).to include("can't be blank")
    end
  end

  describe '#location' do
    subject { Fabricate.build(:area,
                              name: 'Portobello',
                              city: 'Edinburgh',
                              country: 'United Kingdom') }

    it "provides a concatenation of area, city and country" do
      expect(subject.location).to eql('Portobello, Edinburgh, United Kingdom')
    end
  end

  describe 'geocoding' do
    it 'gets latitude and longitude when a new area is added' do
      allow(subject).to receive(:geocode)
      subject.name = 'Portobello'
      subject.valid?
      expect(subject).to have_received(:geocode)
    end

    it 'does not gets latitude and longitude when an existing area has no changes' do
      existing = Fabricate(:area)
      allow(existing).to receive(:geocode)
      existing.valid?
      expect(existing).not_to have_received(:geocode)
    end

    it 'gets latitude and longitude when an existing area has a name change' do
      existing = Fabricate(:area)
      allow(existing).to receive(:geocode)
      existing.name = 'Corstorphine'
      existing.valid?
      expect(existing).to have_received(:geocode)
    end
  end
end
