Fabricator(:text_memory, class_name: :text) do
  user                { Fabricate(:active_user) }
  area
  year                "2014"
  month               "5"
  day                 "4"
  title               "A test"
  description         "This is a test."
  attribution         "Bobby Tables"
  location            "Kings Road"
  categories(rand: 3) { |attrs, i| Fabricate(:category) }
  tags(rand: 3)       { |attrs, i| Fabricate(:tag) }
  moderation_state    ModerationStateMachine::DEFAULT_STATE
end

Fabricator(:memory, class_name: :photo, aliases: [:photo_memory, :pending_memory]) do
  user                { Fabricate(:active_user) }
  area
  year                "2014"
  month               "5"
  day                 "4"
  title               "A test"
  description         "This is a test."
  attribution         "Bobby Tables"
  location            "Kings Road"
  source              Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.jpg'))
  categories(rand: 3) { |attrs, i| Fabricate(:category) }
  tags(rand: 3)       { |attrs, i| Fabricate(:tag) }
  moderation_state    ModerationStateMachine::DEFAULT_STATE
end

Fabricator(:approved_memory, from: :memory) do
  after_create {|memory, transients| memory.approve!(memory.user) }
end

Fabricator(:rejected_memory, from: :memory) do
  after_create {|memory, transients| memory.reject!(memory.user, 'test') }
end

Fabricator(:reported_memory, from: :memory) do
  after_create {|memory, transients| memory.report!(memory.user, 'test') }
end

def stub_memories(number=1)
  Array.new(number) do |i|
    n = i+1
    Fabricate.build(:photo_memory,
           id: n,
           title: "Test #{n}",
           description: "This is test #{n}",
           updated_at: n.days.ago)
  end
end
