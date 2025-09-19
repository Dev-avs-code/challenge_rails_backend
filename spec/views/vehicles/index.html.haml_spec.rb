require 'rails_helper'

RSpec.describe 'vehicles/index', type: :view do
  before(:each) do
    vehicles = create_list(:vehicle, 5)
    assign(:vehicles, Kaminari.paginate_array(vehicles).page(1).per(10))
    render
  end

  it 'renders the main title' do
    expect(rendered).to have_selector('h1.text-primary', text: 'Listing vehicles')
  end

  it 'renders the button to create a new vehicle' do
    expect(rendered).to have_link('New Vehicle', href: new_vehicle_path)
  end

  it 'renders the list headers' do
    expect(rendered).to have_selector('.row.text-primary', text: 'Vin')
    expect(rendered).to have_selector('.row.text-primary', text: 'Plate')
    expect(rendered).to have_selector('.row.text-primary', text: 'Brand')
    expect(rendered).to have_selector('.row.text-primary', text: 'Model')
    expect(rendered).to have_selector('.row.text-primary', text: 'Status')
  end

  it 'renders count of vehicles' do
    expect(rendered).to have_selector('span', text: 'Displaying all 5 entries')
  end
end
