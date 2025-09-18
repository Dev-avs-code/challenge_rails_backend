require 'rails_helper'

RSpec.describe 'api/v1/vehicles', type: :request do
  let(:user) { create(:user) }
  let(:vehicles) { create_list(:vehicle, 5) }
  let(:vehicle) { create(:vehicle) }

  let!(:auth_header) do
    post '/api/v1/auth/login', params: { email: user.email, password: user.password }

    expect(response).to have_http_status(:success)
    token = JSON.parse(response.body)["token"]

    { "Authorization" => "Bearer #{token}" }
  end

  it 'returns list of vehicles' do
    get "/api/v1/vehicles", headers: auth_header

    expect(response).to have_http_status(:ok)
    expect(response.body).to match_response_schema('vehicles/index', strict: true)
  end

  it 'returns a single vehicle' do
    get "/api/v1/vehicles/#{vehicle.id}", headers: auth_header

    expect(response).to have_http_status(:ok)
    expect(response.body).to match_response_schema('vehicles/show', strict: true)
  end

  context 'test with valid params' do

    it 'creates a new vehicle' do
      post '/api/v1/vehicles', params: { vehicle: attributes_for(:vehicle) }, headers: auth_header

      expect(response).to have_http_status(:created)
      expect(response.body).to match_response_schema('vehicles/show', strict: true)
    end

    it 'updates a vehicle' do
      params = {
        vehicle: {
          status: 'inactive'
        }
      }
      put "/api/v1/vehicles/#{vehicle.id}", params: params, headers: auth_header

      expect(response).to have_http_status(:ok)
      expect(response.body).to match_response_schema('vehicles/show', strict: true)
    end
  end

  context 'test with invalid params' do
     it 'creates a new vehicle' do
      params = {
        vehicle: {
          brand: 'Mercedes-Benz',
          model: 'Serie 300'
        }
      }
      post '/api/v1/vehicles', params: params, headers: auth_header

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to match_response_schema('errors', strict: true)
    end

    it 'updates a vehicle' do
      params = {
        vehicle: {
          status: 'other'
        }
      }
      put "/api/v1/vehicles/#{vehicle.id}", params: params, headers: auth_header

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to match_response_schema('errors', strict: true)
    end
  end

  it 'delete a vehicle' do
    delete "/api/v1/vehicles/#{vehicle.id}", headers: auth_header

    expect(response).to have_http_status(:no_content)
  end
end
