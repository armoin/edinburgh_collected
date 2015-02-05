require 'rails_helper'

describe MemoriesHelper do
  describe "#month_names" do
    it "provides an array of the month names prepended with a blank" do
      expected = [
        ['',''],
        ['January',1],
        ['February',2],
        ['March',3],
        ['April',4],
        ['May',5],
        ['June',6],
        ['July',7],
        ['August',8],
        ['September',9],
        ['October',10],
        ['November',11],
        ['December',12],
      ]
      expect(helper.month_names).to eql(expected)
    end
  end

  describe "#sub_text" do
    it "provides an empty string if there is no address and no date" do
      memory = double(address: nil, date_string: nil)
      expect(helper.sub_text(memory)).to eql('')
    end

    it "provides an empty string if there is a blank address and date" do
      memory = double(address: '', date_string: '')
      expect(helper.sub_text(memory)).to eql('')
    end

    it "provides just the address if there is no date" do
      memory = double(address: 'Portobello', date_string: nil)
      expect(helper.sub_text(memory)).to eql('Portobello')
    end

    it "provides just the address if there is a blank date" do
      memory = double(address: 'Portobello', date_string: '')
      expect(helper.sub_text(memory)).to eql('Portobello')
    end

    it "provides just the date if there is no address" do
      memory = double(address: nil, date_string: '4th May 2014')
      expect(helper.sub_text(memory)).to eql('4th May 2014')
    end

    it "provides just the date if there is a blank address" do
      memory = double(address: '', date_string: '4th May 2014')
      expect(helper.sub_text(memory)).to eql('4th May 2014')
    end

    it "provides the address and date if there is an address and a date" do
      memory = double(address: 'Portobello', date_string: '4th May 2014')
      expect(helper.sub_text(memory)).to eql('Portobello, 4th May 2014')
    end
  end

  describe '#scrapbook_modal_data' do
    let(:memory) { double(id: 123, title: 'Test title') }

    subject { helper.scrapbook_modal_data(logged_in, memory) }

    context 'when logged in' do
      let(:logged_in) { true }

      it "provides the data for the modal" do
        expect(subject[:toggle]).to eql('modal')
      end

      it "is bound to the Add to scrapbook modal" do
        expect(subject[:target]).to eql('#add-to-scrapbook-modal')
      end

      it "includes the memory's id" do
        expect(subject[:memory_id]).to eql(memory.id)
      end

      it "includes the memory's title" do
        expect(subject[:memory_title]).to eql(memory.title)
      end
    end

    context 'when not logged in' do
      let(:logged_in) { false }

      it "provides the data for a 'Please sign in' popover" do
        expect(subject[:toggle]).to eql('popover')
      end

      it "is triggered by a click" do
        expect(subject[:trigger]).to eql('click')
      end

      it "has a title" do
        expect(subject).to have_key(:title)
      end

      it "has some content" do
        expect(subject).to have_key(:content)
      end

      it "contains a link to the sign in page in the content" do
        expect(subject[:content]).to include("href=\"#{new_session_path}\"")
      end
    end
  end
end

