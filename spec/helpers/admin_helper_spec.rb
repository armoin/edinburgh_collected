require 'rails_helper'

RSpec.describe AdminHelper do
  describe '#date_sortable_cell' do
    context 'when given a nil date' do
      it 'provides an empty table cell' do
        expect(helper.date_sortable_cell(nil, '')).to eq('<td></td>')
      end
    end

    context 'when given a date' do
      let(:timestamp) { '20160504120506' }
      let(:date)      { Time.zone.parse(timestamp) }

      it 'provides a table cell' do
        expect(helper.date_sortable_cell(date, '%d-%b-%Y')).to match(%r{<td.*</td>})
      end

      it 'includes a custom sort' do
        expect(helper.date_sortable_cell(date, '%d-%b-%Y')).to match(%r{sorttable_customkey="#{timestamp}"})
      end

      context 'when not given a format' do
        it 'contains the date in the default format' do
          expect(helper.date_sortable_cell(date)).to match(%r{>04-May-2016<})
        end
      end

      context 'when given a format that is nil' do
        it 'contains the date in the default format' do
          expect(helper.date_sortable_cell(date, nil)).to match(%r{>04-May-2016<})
        end
      end

      context 'when given a format that is blank' do
        it 'does not contain the date' do
          expect(helper.date_sortable_cell(date, '')).to match(%r{<td.*></td>})
        end
      end

      context 'when given a format that is invalid' do
        it 'outputs the invalid format instead of the date' do
          expect(helper.date_sortable_cell(date, 'd-m-y')).to match(%r{<td.*>d-m-y</td>})
        end
      end

      context 'when a given a format that is valid' do
        it 'contains the date in the given format' do
          expect(helper.date_sortable_cell(date, '%d-%b-%Y %H:%M')).to match(%r{>04-May-2016 12:05<})
        end
      end
    end
  end
end
