require 'spec_helper'

describe Address do
  let(:address) { create(:address) }

  context "update_lat_lng" do
    it 'updates lat lng when fields change' do
      address.street1 = "100 S Main St"
      address.locality = "Los Angeles"
      address.administrative_area = "CA"
      address.postal_code = "90026"
      address.save!

      expect(address.latitude_degrees).to_not eq(nil)
      expect(address.longitude_degrees).to_not eq(nil)
    end

    it 'does not update lat lng when fields do not change' do
      address.latitude_degrees = 16.0
      address.longitude_degrees = -16.0
      address.save!
      expect(address.latitude_degrees).to eq(16.0)
      expect(address.longitude_degrees).to eq(-16.0)
    end
  end
end
