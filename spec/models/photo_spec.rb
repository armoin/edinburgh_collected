require 'rails_helper'

describe Photo do
  let(:file_name) { 'test.jpg' }
  let(:memory)    { Fabricate.build(:photo_memory, user: test_user, source: source, area: area) }

  it_behaves_like "a memory"
end
