RSpec.shared_context 'home_page' do
  before :all do
    @featured_memory = Fabricate(:approved_photo_memory)
    @featured_scrapbook = Fabricate(:approved_scrapbook)
    @featured_scrapbook_memories = Fabricate.times(4, :scrapbook_photo_memory,
                                                      scrapbook: @featured_scrapbook)
    @featured_scrapbook_memory_ids = @featured_scrapbook_memories.map(&:id).join(',')
  end

  after :all do
    @featured_scrapbook.destroy
    @featured_scrapbook_memories.each(&:destroy)
    Memory.destroy_all
    User.destroy_all
  end

  before :each do
    # if we don't stub this method then .create calls will fail as the
    # attached file on the approved_photo_memory is not on HTTP
    allow_any_instance_of(HomePage).to receive(:attach_hero_image)
  end
end
