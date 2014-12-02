RSpec.shared_examples 'a not found memory' do
  context "when requesting HTML" do
    let(:format) { 'html' }

    it "renders the not found page" do
      expect(response).to render_template('exceptions/not_found')
    end

    it "returns an error status" do
      expect(response.status).to eq(404)
    end
  end

  context "when requesting JSON" do
    let(:format) { 'json' }

    it "returns an error status" do
      expect(response.status).to eq(404)
    end
  end

  context "when requesting GeoJSON" do
    let(:format) { 'geojson' }

    it "returns an error status" do
      expect(response.status).to eq(404)
    end
  end
end

