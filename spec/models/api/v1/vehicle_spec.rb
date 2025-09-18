require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  let!(:vehicle) { create(:vehicle) }

  describe "validations" do
    subject { vehicle }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a vin' do
      subject.vin = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with duplicate plate' do
      subject = Vehicle.new(attributes_for(:vehicle, vin: Vehicle.first.vin))
      expect(subject).to_not be_valid
    end
  end

  describe 'update_status!' do
    it 'sets vehicle to in_maintenance if there are pending services' do
      create(:maintenance_service, vehicle: vehicle)
      vehicle.update_status!
      expect(vehicle.reload.status).to eq('in_maintenance')
    end
  end
end
