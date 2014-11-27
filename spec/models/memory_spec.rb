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
  it_behaves_like 'taggable'

  let(:moderatable_model) { Memory }
  let(:moderatable_factory) { :photo_memory }
  it_behaves_like 'moderatable'

  describe 'searching' do
    before :all do
      @term_in_title       = Fabricate(:photo_memory, title: 'Edinburgh Castle test')
      @term_in_description = Fabricate(:photo_memory, description: 'This is an Edinburgh Castle test')
      @term_in_location    = Fabricate(:photo_memory, location: 'Edinburgh Castle')
      @term_in_year        = Fabricate(:photo_memory, year: '1975')
      @terms_not_found     = Fabricate(:photo_memory,
                                       title:       'test',
                                       description: 'test',
                                       location:    'test',
                                       year:        '2014')
    end

    let(:results) { Memory.text_search(terms) }

    context 'when no terms are given' do
      let(:terms) { nil }

      it 'returns all records' do
        expect(results.count(:all)).to eql(5)
      end
    end

    context 'when blank terms are given' do
      let(:terms) { '' }

      it 'returns all records' do
        expect(results.count(:all)).to eql(5)
      end
    end

    context 'text fields' do
      let(:terms) { 'castle' }

      it 'returns all records matching the given query' do
        expect(results.count(:all)).to eql(3)
      end

      it "includes records where title matches" do
        expect(results).to include(@term_in_title)
      end

      it "includes records where description matches" do
        expect(results).to include(@term_in_description)
      end

      it "includes records where location matches" do
        expect(results).to include(@term_in_location)
      end

      it 'does not include records that have no fields that match' do
        expect(results).not_to include(@terms_not_found)
      end
    end

    context 'date fields' do
      let(:terms) { '1975' }

      it 'returns all records matching the given query' do
        expect(results.count(:all)).to eql(1)
      end

      it 'includes records where year matches' do |field|
        expect(results).to include(@term_in_year)
      end

      it 'does not include records that have no fields that match' do
        expect(results).not_to include(@terms_not_found)
      end
    end

    context 'associated fields' do
      let(:terms) { 'foo' }

      context 'categories' do
        before :each do
          @term_in_categories = Fabricate(:photo_memory)
          @term_in_categories.categories << Category.new(name: 'foo')
          @term_in_categories.categories << Category.new(name: 'bar')
        end

        it 'includes records where at least one category name matches' do
          expect(results).to include(@term_in_categories)
        end
      end
    end
  end

  describe 'ordering' do
    describe '.by_recent' do
      it 'sorts them by reverse created at date' do
        memory1 = Fabricate(:photo_memory, user: test_user, area: area)
        memory2 = Fabricate(:photo_memory, user: test_user, area: area)
        expect(Memory.by_recent.first).to eql(memory2)
        expect(Memory.by_recent.last).to eql(memory1)
      end
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
