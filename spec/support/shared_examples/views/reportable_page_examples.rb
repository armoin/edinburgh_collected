RSpec.shared_examples 'a reportable page' do
  context 'when the user is not logged in' do
    let(:user) { nil}

    it 'does not have a report button' do
      render
      expect(rendered).not_to have_link('Report a concern')
    end
  end

  context 'when the user is logged in' do
    let(:user) { Fabricate.build(:active_user, id: 123) }

    before :each do
      allow(user).to receive(:can_modify?).and_return(can_modify)
      render
    end

    context 'and cannot modify the reportable item' do
      let(:can_modify) { false }

      it 'has a report button' do
        expect(rendered).to have_link('Report a concern')
      end
    end

    context 'and can modify the reportable item' do
      let(:can_modify) { true }

      it 'does not have a report button' do
        expect(rendered).not_to have_link('Report a concern')
      end
    end
  end
end
