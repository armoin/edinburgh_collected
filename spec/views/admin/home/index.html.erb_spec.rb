require 'rails_helper'

describe "admin/home/index.html.erb" do
  it "has a link to the moderation page" do
    render
    expect(rendered).to have_link("Moderation", href: admin_unmoderated_path)
  end
end

