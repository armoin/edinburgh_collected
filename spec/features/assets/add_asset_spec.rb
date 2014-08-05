require 'rails_helper'

feature 'adding new assets' do # REMEMBER: add js:true again if this test is reincluded
  let(:asset_attrs) {{
    file_type:   "image",
    title:       "Arthur's Seat",
    year:        "2014",
    description: "Arthur's Seat is the plug of a long extinct volcano."
  }}
  let(:mock_response) { double('response', body: asset_attrs.to_json) }
  let(:mock_conn)     { double('conn', post: mock_response) }

  before :each do
    allow(Faraday).to receive(:new).and_return(mock_conn)
  end

  scenario 'adding a new asset creates it' do
    pending "I'm not sure how much value this is currently giving. Removing until I sort out how to best deal with authentication"

    visit 'user/assets/new'

    select asset_attrs[:file_type], from: 'asset[file_type]'
    attach_file :file, File.join(File.dirname(__FILE__), '../../fixtures/files/test.jpg')
    fill_in 'asset[title]', with: asset_attrs[:title]
    fill_in 'asset[year]', with: asset_attrs[:year]
    fill_in 'asset[description]', with: asset_attrs[:description]

    click_button 'Save'

    expect(mock_conn).to have_received(:post) { "/assets" }
    expect(current_path).to eq('/assets')
  end
end

