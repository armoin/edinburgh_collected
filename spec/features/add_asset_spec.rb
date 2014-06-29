require 'rails_helper'

feature 'adding new assets' do
  before :each do
    @new_asset = {
      title: "A Test",
      file_type: nil,
      url: nil,
      alt: nil,
      description: nil,
      width: nil,
      height: nil,
      resolution: nil,
      device: nil,
      length: nil,
      is_readable: false,
      updated_at: nil,
      created_at: nil,
      _id: "72712d823c14dd7982909d5fbbd3cbec",
      _rev: "1-1bce9054a6a74f7fd2d7ed2c5f2b855e",
      type: "Asset"
    }
    stub_request(:post, "#{@host}/assets").
      to_return(:body => @new_asset.to_json)
    @sample_request << @new_asset
    stub_request(:get, "#{@host}/assets").
      to_return(:body => @sample_request.to_json)
  end

  scenario 'adding a new asset adds it to the users assets' do
    visit '/assets/new'
    attach_file :file, File.join(File.dirname(__FILE__), '../fixtures/files/test.jpg')
    fill_in 'asset[title]', with: 'A Test'
    click_button 'Add Asset'
    expect(current_path).to eq('/assets')
    expect(page).to have_selector('.title', text: 'A Test')
  end
end
