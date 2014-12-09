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
end

