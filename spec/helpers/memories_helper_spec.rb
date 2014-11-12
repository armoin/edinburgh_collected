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
      memory = double(address: nil, date: nil)
      expect(helper.sub_text(memory)).to eql('')
    end

    it "provides an empty string if there is a blank address and date" do
      memory = double(address: '', date: '')
      expect(helper.sub_text(memory)).to eql('')
    end

    it "provides just the address if there is no date" do
      memory = double(address: 'Portobello', date: nil)
      expect(helper.sub_text(memory)).to eql('Portobello')
    end

    it "provides just the address if there is a blank date" do
      memory = double(address: 'Portobello', date: '')
      expect(helper.sub_text(memory)).to eql('Portobello')
    end

    it "provides just the date if there is no address" do
      memory = double(address: nil, date: '4th May 2014')
      expect(helper.sub_text(memory)).to eql('4th May 2014')
    end

    it "provides just the date if there is a blank address" do
      memory = double(address: '', date: '4th May 2014')
      expect(helper.sub_text(memory)).to eql('4th May 2014')
    end

    it "provides the address and date if there is an address and a date" do
      memory = double(address: 'Portobello', date: '4th May 2014')
      expect(helper.sub_text(memory)).to eql('Portobello, 4th May 2014')
    end
  end

  describe "#button_class" do
    let(:memory) { Fabricate.build(:photo_memory) }

    context "when current state is 'unmoderated'" do
      before :each do
        allow(memory).to receive(:current_state).and_return('unmoderated')
        allow(memory).to receive(:current_state_reason).and_return(nil)
      end

      context "when state label does not match supplied button text" do
        it "is enabled" do
          button_class = helper.button_class(memory, 'approved')
          expect(button_class).to eql("unmoderated btn btn-disabled")
        end
      end

      context "when state label matches button text" do
        it "is disabled" do
          button_class = helper.button_class(memory, 'unmoderated')
          expect(button_class).to eql("unmoderated btn btn-unmoderated")
        end
      end
    end

    context "when current state is 'rejected' and reason is 'unsuitable'" do
      before :each do
        allow(memory).to receive(:current_state).and_return('rejected')
        allow(memory).to receive(:current_state_reason).and_return('unsuitable')
      end

      context "when state label does not match supplied button text" do
        it "is enabled" do
          button_class = helper.button_class(memory, 'approved')
          expect(button_class).to eql("unmoderated btn btn-disabled")
        end
      end

      context "when state label matches button text" do
        it "is disabled" do
          button_class = helper.button_class(memory, 'rejected - unsuitable')
          expect(button_class).to eql("rejected btn btn-rejected")
        end
      end
    end
  end
end

