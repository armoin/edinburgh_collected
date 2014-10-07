RSpec.shared_examples 'locatable' do
  describe "location" do
    let(:memory) { Fabricate.build(:photo_memory, area: area, location: location) }

    context "when memory has no area or location" do
      let(:area)     { nil }
      let(:location) { nil }

      context "on create" do
        it "does not fetch lat long" do
          allow(memory).to receive(:geocode).and_return(true)
          memory.valid?
          expect(memory).not_to have_received(:geocode)
        end
      end

      context "on update" do
        before :each do
          memory.save!
          allow(memory).to receive(:geocode).and_return(true)
        end

        it "does not fetch lat long if area has been added" do
          memory.area = Fabricate.build(:area)
          memory.valid?
          expect(memory).not_to have_received(:geocode)
        end

        it "fetches lat long if location has been added" do
          memory.location = 'new street'
          memory.valid?
          expect(memory).to have_received(:geocode)
        end
      end
    end

    context "when memory has area but no location" do
      let(:area)     { Fabricate.build(:area) }
      let(:location) { nil }

      context "on create" do
        it "does not fetch lat long" do
          allow(memory).to receive(:geocode).and_return(true)
          memory.valid?
          expect(memory).not_to have_received(:geocode)
        end
      end

      context "on update" do
        before :each do
          memory.save!
          allow(memory).to receive(:geocode).and_return(true)
        end

        it "does not fetch lat long if area has been changed" do
          memory.area = Fabricate(:area)
          memory.valid?
          expect(memory).not_to have_received(:geocode)
        end

        it "fetches lat long if location has been added" do
          memory.location = 'new street'
          memory.valid?
          expect(memory).to have_received(:geocode)
        end
      end
    end

    context "when memory has location but no area" do
      let(:area)     { nil }
      let(:location) { 'old street' }

      context "on create" do
        it "fetches lat long" do
          allow(memory).to receive(:geocode).and_return(true)
          memory.valid?
          expect(memory).to have_received(:geocode)
        end
      end

      context "on update" do
        before :each do
          memory.latitude = 1.23
          memory.longitude = 3.21
          memory.save!
          allow(memory).to receive(:geocode).and_return(true)
        end

        it "fetches lat long if area has been added" do
          memory.area = Fabricate(:area)
          memory.valid?
          expect(memory).to have_received(:geocode)
        end

        context "when location has been changed" do
          before :each do
            memory.location = 'new street'
            memory.valid?
          end

          it "fetches lat long" do
            expect(memory).to have_received(:geocode)
          end

          it "does not blank latitude and longitude" do
            expect(memory.latitude).not_to be_nil
            expect(memory.longitude).not_to be_nil
          end
        end

        context "when location has been removed" do
          before :each do
            memory.location = nil
            memory.valid?
          end

          it "does not fetch lat long" do
            expect(memory).not_to have_received(:geocode)
          end

          it "blanks latitude and longitude" do
            expect(memory.read_attribute(:latitude)).to be_nil
            expect(memory.read_attribute(:longitude)).to be_nil
          end
        end
      end
    end

    context "when memory has location and area" do
      let(:area)     { Fabricate.build(:area) }
      let(:location) { 'old street' }

      context "on create" do
        it "fetches lat long" do
          allow(memory).to receive(:geocode).and_return(true)
          memory.valid?
          expect(memory).to have_received(:geocode)
        end
      end

      context "on update" do
        before :each do
          memory.latitude = 1.23
          memory.longitude = 3.21
          memory.save!
          allow(memory).to receive(:geocode).and_return(true)
        end

        it "fetches lat long if area has been changed" do
          memory.area = Fabricate(:area)
          memory.valid?
          expect(memory).to have_received(:geocode)
        end

        context "when location has been changed" do
          before :each do
            memory.location = 'new street'
            memory.valid?
          end

          it "fetches lat long" do
            expect(memory).to have_received(:geocode)
          end

          it "does not blank latitude and longitude" do
            expect(memory.latitude).not_to be_nil
            expect(memory.longitude).not_to be_nil
          end
        end

        context "when location has been removed" do
          before :each do
            memory.location = nil
            memory.valid?
          end

          it "does not fetch lat long" do
            expect(memory).not_to have_received(:geocode)
          end

          it "blanks latitude and longitude" do
            expect(memory.read_attribute(:latitude)).to be_nil
            expect(memory.read_attribute(:longitude)).to be_nil
          end
        end
      end
    end
  end

  describe 'latitude and longitude' do
    context 'when memory has no latitude and longitude' do
      let(:area)   { Fabricate.build(:area, latitude: 1.23, longitude: 3.21) }
      let(:memory) { Fabricate.build(:photo_memory, area: area, latitude: nil, longitude: nil) }

      it "uses the area's latitude" do
        expect(memory.latitude).to eql(area.latitude)
      end

      it "uses the area's longitude" do
        expect(memory.longitude).to eql(area.longitude)
      end
    end
  end

  describe "has_coords?" do
    before :each do
      # coords fall through to area if blank
      memory.area = nil
    end

    it "is false if the model has no latitude or longitdude" do
      memory.longitude = nil
      memory.latitude = nil
      expect(memory).not_to have_coords
    end

    it "is false if the model has no latitude" do
      memory.longitude = 123.0
      memory.latitude = nil
      expect(memory).not_to have_coords
    end

    it "is false if the model has no longitude" do
      memory.longitude = nil
      memory.latitude = 3.21
      expect(memory).not_to have_coords
    end

    it "is true if the model has both latitude and longitdude" do
      memory.longitude = 123.0
      memory.latitude = 3.21
      expect(memory).to have_coords
    end
  end
end

