RSpec.shared_examples 'a found memory' do
  context "when requesting HTML" do
    it "renders the show page" do
      expect(response).to render_template(:show)
    end
  end

  context "when requesting JSON" do
    let(:format) { :json }

    it "provides JSON" do
      expect(response.content_type).to eql('application/json')
    end

    it 'is successful' do
      expect(response.status).to eq(200)
    end
  end

  context "when requesting GeoJSON" do
    let(:format) { :geojson }

    it "provides GeoJSON" do
      expect(response.content_type).to eql('text/geojson')
    end

    it 'is successful' do
      expect(response.status).to eq(200)
    end
  end
end

