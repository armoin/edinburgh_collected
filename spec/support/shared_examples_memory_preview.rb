RSpec.shared_examples 'a memory preview' do
  let(:memory_class) { find('.memory') }

  it "shows the user's avatar photo" do
    img = memory_class.find('.userAvatar img')
    expect(img['src']).to have_content("http://placehold.it/72x72")
    expect(img['alt']).to have_content("username")
  end

  it 'has a title' do
    expect(memory_class.find('.title')).to have_text("A test")
  end

  it 'has an image' do
    img = memory_class.find('.photo img')
    expect(img['src']).to have_content("test.jpg")
    expect(img['alt']).to have_content("A test")
  end

  it 'has a description' do
    expect(memory_class).to have_css('p', text: "This is a test.", count: 1)
  end

  it "has a location and date" do
    sub_text = memory_class.find('.sub').native.text
    expect(sub_text).to eql("Kings Road, Portobello, 4th May 2014")
  end

  it 'has an attribution' do
    expect(memory_class).to have_css('p', text: "Bobby Tables", count: 1)
  end

  it 'has a comma separated list of categories' do
    expect(memory_class).to have_css('p', text: memory.category_list, count: 1)
  end
end
