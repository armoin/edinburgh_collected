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
end

