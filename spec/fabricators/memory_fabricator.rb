Fabricator(:memory, class_name: :written, aliases: [:written_memory, :pending_memory]) do
  user                { Fabricate(:approved_user) }
  title               "A test"
  description         "This is a test."
  categories(rand: 3) { |attrs, i| Fabricate(:category) }
  moderation_state    ModerationStateMachine::DEFAULT_STATE
end

Fabricator(:photo_memory, class_name: :photo, from: :memory) do
  area
  year                "2014"
  month               "5"
  day                 "4"
  attribution         "Bobby Tables"
  location            "Kings Road"
  source              Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.jpg'))
  tags(rand: 3)       { |attrs, i| Fabricate(:tag) }
end

Fabricator(:approved_memory, from: :memory, aliases: ['approved_written_memory']) do
  after_create {|memory, transients| memory.approve!(memory.user) }
end

Fabricator(:approved_photo_memory, from: :photo_memory) do
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
    Fabricate.build(:memory,
           id: n,
           title: "Test #{n}",
           description: "This is test #{n}",
           updated_at: n.days.ago)
  end
end
