RSpec.shared_examples 'a shareable page' do
  it 'has a share bar' do
    render
    expect(rendered).to have_css('.addthis_sharing_toolbox')
  end
end