require 'rails_helper'

describe Memory do
  let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'files') }
  let(:file_name) { 'test.jpg' }
  let(:source)    { Rack::Test::UploadedFile.new(File.join(file_path, file_name)) }
  let(:test_user) { Fabricate.build(:user) }
  let(:memory)    { Fabricate.build(:photo_memory, user: test_user, source: source, area: area) }

  let!(:area) { Fabricate(:area) }

  it_behaves_like 'a memory'
  it_behaves_like 'locatable'

  describe 'ordering' do
    it 'sorts them by reverse created at date' do
      memory1 = Fabricate(:photo_memory, user: test_user, area: area)
      memory2 = Fabricate(:photo_memory, user: test_user, area: area)
      expect(Memory.first).to eql(memory2)
      expect(Memory.last).to eql(memory1)
    end
  end

  describe 'year calculators' do
    before :each do
      Timecop.freeze('2014-01-01')
    end

    after :each do
      Timecop.return
    end

    describe 'current_year' do
      it 'returns the current year' do
        expect(Memory.current_year).to eql(2014)
      end
    end

    describe 'furthest_year' do
      it 'returns the year 120 years before the current year' do
        expect(Memory.furthest_year).to eql(1894)
      end
    end
  end

  describe "date" do
    it "provides the year when memory only has a year" do
      expect(Memory.new(year: "2014").date).to eql("2014")
    end

    it "provides the month and year when memory has a month" do
      expect(Memory.new(year: "2014", month: "05").date).to eql("May 2014")
    end

    it "provides the day, month and year when memory has a month and a day" do
      expect(Memory.new(year: "2014", month: "05", day: "04").date).to eql("4th May 2014")
    end

    it "handles blanks" do
      expect(Memory.new(year: "2014", month: "", day: "").date).to eql("2014")
      expect(Memory.new(year: "2014", month: "05", day: "").date).to eql("May 2014")
      expect(Memory.new(year: "2014", month: "", day: "04").date).to eql("2014")
    end
  end

  describe "address" do
    it "is blank if there is no area and no location" do
      memory.area = nil
      memory.location = nil
      expect(memory.address).to eql('')
    end

    it "provides the area name if there is an area but no location" do
      memory.location = nil
      expect(memory.address).to eql('Portobello')
    end

    it "provides the area name if there is an area but blank location" do
      memory.location = ""
      expect(memory.address).to eql('Portobello')
    end

    it "provides the location and area name if there is an area and location" do
      expect(memory.address).to eql('Kings Road, Portobello')
    end
  end

  describe "#category_list" do
    before :each do
      memory.categories.destroy_all
    end

    it "provides an empty string if there are no categories" do
      expect(memory.category_list).to eql('')
    end

    it "provides a single category string if there is one category" do
      memory.categories.build(name: 'Home')
      expect(memory.category_list).to eql('Home')
    end

    it "provides a comma separated list of categories if there are two categories" do
      memory.categories.build(name: 'Home')
      memory.categories.build(name: 'Transport')
      expect(memory.category_list).to eql('Home, Transport')
    end
  end
end
