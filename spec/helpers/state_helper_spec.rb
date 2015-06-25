require 'rails_helper'

describe StateHelper do
  let(:memory) { Fabricate.build(:photo_memory, id: 123) }

  describe '#button_for_state' do
    describe 'for memories' do
      let(:moderatable_name) { :memory }

      it_behaves_like 'a button for state helper'
    end

    describe 'for scrapbooks' do
      let(:moderatable_name) { :scrapbook }

      it_behaves_like 'a button for state helper'
    end
  end

  describe '#state_label_text' do
    context 'when there is no reason' do
      before :each do
        allow(memory).to receive(:moderation_state).and_return('unmoderated')
        allow(memory).to receive(:moderation_reason).and_return(nil)
      end

      it 'just provides the moderation state' do
        expect(helper.state_label_text(memory)).to eql('unmoderated')
      end
    end

    context 'when there is a blank reason' do
      before :each do
        allow(memory).to receive(:moderation_state).and_return('approved')
        allow(memory).to receive(:moderation_reason).and_return('')
      end

      it 'just provides the moderation state' do
        expect(helper.state_label_text(memory)).to eql('approved')
      end
    end

    context 'when there is a reason' do
      before :each do
        allow(memory).to receive(:moderation_state).and_return('rejected')
        allow(memory).to receive(:moderation_reason).and_return('unsuitable')
      end

      it 'provides the moderation state and the reason' do
        expect(helper.state_label_text(memory)).to eql('rejected - unsuitable')
      end
    end
  end

  describe '#show_state_label?' do
    let(:user)        { double('user', can_modify?: can_modify) }
    let(:moderatable) { double('moderatable', moderation_state: state) }
    let(:approved)    { false }
    let(:can_modify)  { true }

    before :each do
      allow(helper).to receive(:current_user).and_return(user)
    end

    context 'when the user is able to modify the item' do
      let(:can_modify)  { true }

      context 'and the item is not approved' do
        let(:state) { 'unmoderated' }

        context 'and the user is on a page where state labels are shown' do
          it "shows state on the show page of memories that belong to the user" do
            allow(helper).to receive(:controller_path).and_return('my/memories')
            expect(helper.show_state_label?(moderatable)).to be_truthy
          end

          it "shows state on the show page of scrapbooks that belong to the user" do
            allow(helper).to receive(:controller_path).and_return('my/scrapbooks')
            expect(helper.show_state_label?(moderatable)).to be_truthy
          end
        end

        context 'and the user is on a page where state labels are not shown' do
          it 'does not show state' do
            allow(helper).to receive(:controller_path).and_return('test/not/viewable')
            expect(helper.show_state_label?(moderatable)).to be_falsy
          end
        end
      end

      context 'and the item is approved' do
        let(:state) { 'approved' }

        context 'and the user is on a page where state labels are shown' do
          it "does not show state on the show page of memories that belong to the user" do
            allow(helper).to receive(:controller_path).and_return('my/memories')
            expect(helper.show_state_label?(moderatable)).to be_falsy
          end

          it "does not show state on the show page of scrapbooks that belong to the user" do
            allow(helper).to receive(:controller_path).and_return('my/scrapbooks')
            expect(helper.show_state_label?(moderatable)).to be_falsy
          end
        end

        context 'and the user is on a page where state labels are not shown' do
          it 'does not show state' do
            allow(helper).to receive(:controller_path).and_return('test/not/viewable')
            expect(helper.show_state_label?(moderatable)).to be_falsy
          end
        end
      end
    end

    context 'when the user is not able to modify the item' do
      let(:can_modify)  { false }

      context 'and the item is not approved' do
        let(:state) { 'unmoderated' }

        context 'and the user is on a page where state labels are shown' do
          it "does not show state on the show page of memories that belong to the user" do
            allow(helper).to receive(:controller_path).and_return('my/memories')
            expect(helper.show_state_label?(moderatable)).to be_falsy
          end

          it "does not show state on the show page of scrapbooks that belong to the user" do
            allow(helper).to receive(:controller_path).and_return('my/scrapbooks')
            expect(helper.show_state_label?(moderatable)).to be_falsy
          end
        end

        context 'and the user is on a page where state labels are not shown' do
          it 'does not show state' do
            allow(helper).to receive(:controller_path).and_return('test/not/viewable')
            expect(helper.show_state_label?(moderatable)).to be_falsy
          end
        end
      end

      context 'and the item is approved' do
        let(:state) { 'approved' }

        context 'and the user is on a page where state labels are shown' do
          it "does not show state on the show page of memories that belong to the user" do
            allow(helper).to receive(:controller_path).and_return('my/memories')
            expect(helper.show_state_label?(moderatable)).to be_falsy
          end

          it "does not show state on the show page of scrapbooks that belong to the user" do
            allow(helper).to receive(:controller_path).and_return('my/scrapbooks')
            expect(helper.show_state_label?(moderatable)).to be_falsy
          end
        end

        context 'and the user is on a page where state labels are not shown' do
          it 'does not show state' do
            allow(helper).to receive(:controller_path).and_return('test/not/viewable')
            expect(helper.show_state_label?(moderatable)).to be_falsy
          end
        end
      end
    end
  end
end

