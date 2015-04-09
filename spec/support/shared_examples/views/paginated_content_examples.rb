RSpec.shared_examples 'paginated content' do
  it 'is paginated' do
    expect(rendered).to have_css('.pagination-container')
  end
end

