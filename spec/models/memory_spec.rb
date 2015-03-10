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

  describe 'filtering' do
    describe 'by category' do
      subject { Memory.filter_by_category(category) }

      before :each do
        @term_only_category = Fabricate(:approved_memory)
        @term_only_category.categories << Category.new(name: 'foo')

        @term_in_categories = Fabricate(:approved_memory)
        @term_in_categories.categories << Category.new(name: 'foo')
        @term_in_categories.categories << Category.new(name: 'bar')

        @term_not_in_categories = Fabricate(:approved_memory)
        @term_not_in_categories.categories << Category.new(name: 'bar')
      end

      context 'when no category is given' do
        let(:category) { nil }

        it 'returns all records' do
          expect(subject).to include(@term_only_category)
          expect(subject).to include(@term_in_categories)
          expect(subject).to include(@term_not_in_categories)
        end
      end

      context 'when blank category is given' do
        let(:category) { '' }

        it 'returns all records' do
          expect(subject).to include(@term_only_category)
          expect(subject).to include(@term_in_categories)
          expect(subject).to include(@term_not_in_categories)
        end
      end

      context 'when a category is given' do
        let(:category) { 'foo' }

        it 'includes records that have the category but no others' do
          expect(subject).to include(@term_only_category)
        end

        it 'includes records that have the category amongst others' do
          expect(subject).to include(@term_in_categories)
        end

        it "doesn't include records that don't have the category" do
          expect(subject).not_to include(@term_not_in_categories)
        end
      end
    end

    describe 'by tag' do
      subject { Memory.filter_by_tag(tag) }

      before :each do
        @term_only_tag = Fabricate(:approved_memory)
        @term_only_tag.tags << Tag.new(name: 'foo')

        @term_in_tags = Fabricate(:approved_memory)
        @term_in_tags.tags << Tag.new(name: 'foo')
        @term_in_tags.tags << Tag.new(name: 'bar')

        @term_not_in_tags = Fabricate(:approved_memory)
        @term_not_in_tags.tags << Tag.new(name: 'bar')
      end

      context 'when no tag is given' do
        let(:tag) { nil }

        it 'returns all records' do
          expect(subject).to include(@term_only_tag)
          expect(subject).to include(@term_in_tags)
          expect(subject).to include(@term_not_in_tags)
        end
      end

      context 'when blank tag is given' do
        let(:tag) { '' }

        it 'returns all records' do
          expect(subject).to include(@term_only_tag)
          expect(subject).to include(@term_in_tags)
          expect(subject).to include(@term_not_in_tags)
        end
      end

      context 'when a tag is given' do
        let(:tag) { 'foo' }

        it 'includes records that have the tag but no others' do
          expect(subject).to include(@term_only_tag)
        end

        it 'includes records that have the tag amongst others' do
          expect(subject).to include(@term_in_tags)
        end

        it "doesn't include records that don't have the tag" do
          expect(subject).not_to include(@term_not_in_tags)
        end
      end
    end

    describe 'by area' do
      subject { Memory.filter_by_area(area) }

      before :each do
        foo_area = Fabricate(:area, name: 'foo')
        bar_area = Fabricate(:area, name: 'bar')

        @matches_area = Fabricate(:approved_memory, area: foo_area)
        @does_not_match_area = Fabricate(:approved_memory, area: bar_area)
      end

      context 'when no area is given' do
        let(:area) { nil }

        it 'returns all records' do
          expect(subject).to include(@matches_area)
          expect(subject).to include(@does_not_match_area)
        end
      end

      context 'when blank area is given' do
        let(:area) { '' }

        it 'returns all records' do
          expect(subject).to include(@matches_area)
          expect(subject).to include(@does_not_match_area)
        end
      end

      context 'when a area is given' do
        let(:area) { 'foo' }

        it 'includes records that have the area' do
          expect(subject).to include(@matches_area)
        end

        it "doesn't include records that don't have the area" do
          expect(subject).not_to include(@does_not_match_area)
        end
      end
    end
  end

  describe 'searching' do
    before :each do
      @unapproved_term_in_title = Fabricate(:memory, title: 'Edinburgh Castle test')
      @term_in_title            = Fabricate(:approved_memory, title: 'Edinburgh Castle test')
      @term_in_description      = Fabricate(:approved_memory, description: 'This is an Edinburgh Castle test')
      @term_in_location         = Fabricate(:approved_memory, location: 'Edinburgh Castle')
      @term_in_year             = Fabricate(:approved_memory, year: '1975')
      @terms_not_found          = Fabricate(:approved_memory,
                                              title:       'test',
                                              description: 'test',
                                              location:    'test',
                                              year:        '2014')
    end

    let(:results) { Memory.text_search(terms) }

    context 'when no terms are given' do
      let(:terms) { nil }

      it 'returns all approved records' do
        expect(results.count(:all)).to eql(5)
      end

      it 'does not return unapproved records' do
        expect(results).not_to include(@unapproved_term_in_title)
      end
    end

    context 'when blank terms are given' do
      let(:terms) { '' }

      it 'returns all approved records' do
        expect(results.count(:all)).to eql(5)
      end

      it 'does not return unapproved records' do
        expect(results).not_to include(@unapproved_term_in_title)
      end
    end

    context 'text fields' do
      let(:terms) { 'castle' }

      it 'returns all approved records matching the given query' do
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
        expect(results).not_to include(@unapproved_term_in_title)
      end

      it 'does not include unapproved records that have fields that match' do
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
          @term_in_categories = Fabricate(:approved_memory)
          @term_in_categories.categories << Category.new(name: 'foo')
          @term_in_categories.categories << Category.new(name: 'bar')

          @term_not_in_categories = Fabricate(:approved_memory)
          @term_not_in_categories.categories << Category.new(name: 'bar')
        end

        it 'includes records where at least one category name matches' do
          expect(results).to include(@term_in_categories)
        end

        it 'does not include records where at least no category names match' do
          expect(results).not_to include(@term_not_in_categories)
        end
      end

      context 'tags' do
        before :each do
          @term_in_tags = Fabricate(:approved_memory)
          @term_in_tags.tags << Tag.new(name: 'foo')
          @term_in_tags.tags << Tag.new(name: 'bar')

          @term_not_in_tags = Fabricate(:approved_memory)
          @term_not_in_tags.tags << Tag.new(name: 'bar')
        end

        it 'includes records where at least one tag name matches' do
          expect(results).to include(@term_in_tags)
        end

        it 'does not include records where at least no tag names match' do
          expect(results).not_to include(@term_not_in_tags)
        end
      end

      context 'area' do
        before :each do
          foo_area = Fabricate.build(:area, name: 'foo', id: 1)
          @term_in_area = Fabricate(:approved_memory, area: foo_area)

          bar_area = Fabricate.build(:area, name: 'bar', id: 2)
          @term_not_in_area = Fabricate(:approved_memory, area: bar_area)
        end

        it 'includes records where at least one area name matches' do
          expect(results).to include(@term_in_area)
        end

        it 'does not include records where at least no area names match' do
          expect(results).not_to include(@term_not_in_area)
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

  describe "date_string" do
    it "provides the year when memory only has a year" do
      expect(Memory.new(year: "2014").date_string).to eql("2014")
    end

    it "provides the month and year when memory has a month" do
      expect(Memory.new(year: "2014", month: "05").date_string).to eql("May 2014")
    end

    it "provides the day, month and year when memory has a month and a day" do
      expect(Memory.new(year: "2014", month: "05", day: "04").date_string).to eql("4th May 2014")
    end

    it "handles blanks" do
      expect(Memory.new(year: "2014", month: "", day: "").date_string).to eql("2014")
      expect(Memory.new(year: "2014", month: "05", day: "").date_string).to eql("May 2014")
      expect(Memory.new(year: "2014", month: "", day: "04").date_string).to eql("2014")
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
