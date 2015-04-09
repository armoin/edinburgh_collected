RSpec.shared_examples 'taggable' do
  describe '#tag_list=' do
    let(:mock_tags) { double('tags') }

    before :each do
      allow(Tag).to receive(:where).and_return(mock_tags)
      allow(mock_tags).to receive(:first_or_create!).and_return(Fabricate(:tag))
    end

    it 'creates no tags if no tag_list is given' do
      subject.tag_list = nil
      expect(mock_tags).not_to have_received(:first_or_create!)
    end

    it 'creates no tags if an empty tag_list is given' do
      subject.tag_list = ''
      expect(mock_tags).not_to have_received(:first_or_create!)
    end

    it 'creates one tag if a single tag is given' do
      subject.tag_list = 'test'
      expect(mock_tags).to have_received(:first_or_create!).once
    end

    it 'creates three tags if three tags given' do
      subject.tag_list = 'test, more, tags'
      expect(mock_tags).to have_received(:first_or_create!).exactly(3).times
    end

    it 'strips unwanted whitespace' do
      subject.tag_list = '   space'
      expect(Tag).to have_received(:where).with(name: 'space').at_least(:once)
    end

    it 'assigns tags' do
      subject.tag_list = 'test, more, tags'
      expect(subject.tags.length).to eql(3)
    end
  end

  describe '#tag_list' do
    it "returns an empty string if there are no tags" do
      expect(subject.tag_list).to eql('')
    end

    it "returns a single tag name if there is only one tag" do
      subject.tag_list = 'test'
      expect(subject.tag_list).to eql('test')
    end

    it "returns a comma separated list if there is more than one tag" do
      subject.tag_list = 'test, more, tags'
      expect(subject.tag_list).to eql('test, more, tags')
    end
  end
end
