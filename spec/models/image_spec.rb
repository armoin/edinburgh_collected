require 'rails_helper'

describe Image do
  let(:file_name) { 'test.jpg' }
  let(:memory)    { Fabricate.build(:image_memory, user: test_user, source: source, area: area) }

  it_behaves_like "a memory"
end
