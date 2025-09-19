require 'rails_helper'

RSpec.describe MaintenanceServicesController, type: :controller do
  let!(:vehicle) { create(:vehicle) }
  let!(:maintenance_service) { create(:maintenance_service, vehicle: vehicle) }

  it 'returns all maintenance services for the vehicle' do
    get :index, params: { vehicle_id: vehicle.id }

    expect(response).to have_http_status(:ok)
  end

  it 'renders the new template' do
    get :new, params: { vehicle_id: vehicle.id }

    expect(response).to have_http_status(:ok)
  end

  it 'renders the edit template' do
    get :edit, params: { vehicle_id: vehicle.id, id: maintenance_service.id }

    expect(response).to have_http_status(:ok)
  end


  describe 'POST /create' do
    context 'with valid params' do
      it 'creates a new maintenance service via turbo_stream' do
        expect {
          post :create, params: { maintenance_service: attributes_for(:maintenance_service), vehicle_id: vehicle.id }, as: :turbo_stream
        }.to change(MaintenanceService, :count).by(1)

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context 'with invalid params' do
      it 'does not create and renders errors' do
        expect {
          post :create,
                params: { maintenance_service: attributes_for(:maintenance_service, status: 'other'), vehicle_id: vehicle.id }
        }.not_to change(MaintenanceService, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    let(:update_params) { { maintenance_service: { description: 'Other description' }, vehicle_id: vehicle.id, id: maintenance_service.id} }

    it 'updates the maintenance service via turbo_stream' do
      patch :update, params: update_params, as: :turbo_stream

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(maintenance_service.reload.description).to eq('Other description')
    end
  end
end
