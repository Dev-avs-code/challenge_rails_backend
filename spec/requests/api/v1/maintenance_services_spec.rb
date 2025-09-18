require 'rails_helper'

RSpec.describe 'maintenance_services', type: :request do
  let(:user) { create(:user) }
  let(:vehicle) { create(:vehicle) }
  let(:services) { create_list(:maintenance_service, 5, vehicle: vehicle) }
  let(:service) { services.first }

  let!(:auth_header) do
    post '/api/v1/auth/login', params: { email: user.email, password: user.password }

    expect(response).to have_http_status(:success)
    token = JSON.parse(response.body)["token"]

    { "Authorization" => "Bearer #{token}" }
  end

  it 'returns all maintenance services for a vehicle' do
      get "/api/v1/vehicles/#{vehicle.id}/maintenance_services", headers: auth_header

      expect(response).to have_http_status(:ok)
      expect(response).to match_response_schema('maintenance_services/index')
  end

  context 'test with valid params' do
    it 'creates a maintenance service for a vehicle' do
      post "/api/v1/vehicles/#{vehicle.id}/maintenance_services",
            params: { maintenance_service: attributes_for(:maintenance_service) }, headers: auth_header

      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema('maintenance_services/show')
    end

    it 'updates a maintenance service' do
      params = {
        maintenance_service: {
          status: 'in_progress'
        }
      }
      put "/api/v1/maintenance_services/#{service.id}", params: params, headers: auth_header

      expect(response).to have_http_status(:ok)
      expect(response).to match_response_schema('maintenance_services/show')
    end
  end

  context 'test with invalid params' do
    it 'creates a maintenance service for a vehicle' do
      post "/api/v1/vehicles/#{vehicle.id}/maintenance_services",
            params: { maintenance_service: attributes_for(:maintenance_service, status: 'other_status') },
            headers: auth_header

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to match_response_schema('errors')
    end

    it 'updates a maintenance service' do
      params = {
        maintenance_service: {
          status: 'completed'
        }
      }
      put "/api/v1/maintenance_services/#{service.id}", params: params, headers: auth_header

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to match_response_schema('errors')
    end
  end
end
