require 'rails_helper'

RSpec.describe 'maintenance_services/index', type: :view do
  let!(:vehicle) { create(:vehicle)}
  let!(:maintenance_services) { create_list(:maintenance_service, 5, vehicle: vehicle) }

  before(:each) do
    assign(:vehicle, vehicle)
    assign(:maintenance_services, Kaminari.paginate_array(maintenance_services).page(1).per(10))
    render
  end

  it 'renders the main title with vehicle VIN' do
    expect(rendered).to have_selector('h2.text-primary', text: "Maintenance services for vehicle #{vehicle.vin}")
  end

  it 'renders the vehicle card with details' do
    expect(rendered).to have_content('Vehicle Information')
    expect(rendered).to have_content(vehicle.vin)
    expect(rendered).to have_content(vehicle.plate)
    expect(rendered).to have_content('In Maintenance')
  end

  it 'renders table headers' do
    expect(rendered).to have_selector('.row.text-primary', text: 'ID')
    expect(rendered).to have_selector('.row.text-primary', text: 'Description')
    expect(rendered).to have_selector('.row.text-primary', text: 'Status')
    expect(rendered).to have_selector('.row.text-primary', text: 'Cost ents')
    expect(rendered).to have_selector('.row.text-primary', text: 'Priority')
    expect(rendered).to have_selector('.row.text-primary', text: 'Completed at')
  end

  it 'renders each maintenance service inside a turbo-frame' do
    maintenance_services.each do |service|
      expect(rendered).to have_selector("turbo-frame#maintenance_service_#{service.id}")
      expect(rendered).to have_content(service.description)
      expect(rendered).to have_content(service.status)
      expect(rendered).to have_content(service.priority)
      expect(rendered).to have_link('Edit', href: "/vehicles/#{vehicle.id}/maintenance_services/#{service.id}/edit")
    end
  end
end
