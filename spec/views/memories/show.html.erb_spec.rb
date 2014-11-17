require 'rails_helper'

describe "memories/show.html.erb" do
  let(:memory) { Fabricate.build(:photo_memory, id: 123) }

  it_behaves_like "a memory show page"
end
