require 'rails_helper'

RSpec.describe HomePagePresenter do
  describe '#has_featured_memory?' do
    subject(:presenter) { HomePagePresenter.new(home_page) }

    context 'when given a nil HomePage' do
      let(:home_page) { nil }

      it 'is false' do
        expect(presenter).not_to have_featured_memory
      end
    end

    context 'when given a HomePage with no featured memory' do
      let(:home_page) { HomePage.new }

      it 'is false' do
        expect(presenter).not_to have_featured_memory
      end
    end

    context 'when given a HomePage with a featured memory' do
      let(:home_page) { HomePage.new(featured_memory: Fabricate.build(:approved_photo_memory)) }

      it 'is true' do
        expect(presenter).to have_featured_memory
      end
    end
  end

  describe '#has_featured_scrapbook?' do
    subject(:presenter) { HomePagePresenter.new(home_page) }

    context 'when given a nil HomePage' do
      let(:home_page) { nil }

      it 'is false' do
        expect(presenter).not_to have_featured_scrapbook
      end
    end

    context 'when given a HomePage with no featured scrapbook' do
      let(:home_page) { HomePage.new }

      it 'is false' do
        expect(presenter).not_to have_featured_scrapbook
      end
    end

    context 'when given a HomePage with a featured scrapbook' do
      let(:home_page) { HomePage.new(featured_scrapbook: Fabricate.build(:approved_scrapbook)) }

      it 'is true' do
        expect(presenter).to have_featured_scrapbook
      end
    end
  end
end
