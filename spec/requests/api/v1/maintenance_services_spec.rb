require 'rails_helper'

RSpec.describe 'maintenance_services', type: :request do
  let(:user) { create(:user) }
  let(:vehicle) { create(:vehicle) }
  let(:services) { create_list(:maintenance_service, 5, vehicle: vehicle) }
  let(:service) { services.first }

  context 'with authorize user' do
    it 'shoul return a list of maintenance services for a vehicle' do
      get "/api/v1/vehicles/#{vehicle.id}/maintenance_services", headers: valid_token_header(user)

      expect(response).to have_http_status(:ok)
      expect(response).to match_response_schema('maintenance_services/index')
    end

    context 'with valid params' do
      it 'should create a maintenance service for a vehicle' do
        post "/api/v1/vehicles/#{vehicle.id}/maintenance_services",
              params: { maintenance_service: attributes_for(:maintenance_service) }, headers: valid_token_header(user)

        expect(response).to have_http_status(:created)
        expect(response).to match_response_schema('maintenance_services/show')
      end

      it 'should updates a maintenance service' do
        params = {
          maintenance_service: {
            status: 'in_progress'
          }
        }
        put "/api/v1/maintenance_services/#{service.id}", params: params, headers: valid_token_header(user)

        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema('maintenance_services/show')
      end
    end

    context 'with invalid params' do
      it 'should not create a maintenance service for a vehicle' do
        post "/api/v1/vehicles/#{vehicle.id}/maintenance_services",
              params: { maintenance_service: attributes_for(:maintenance_service, status: 'other_status') },
              headers: valid_token_header(user)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to match_response_schema('errors')
      end

      it 'should not updates a maintenance service' do
        params = {
          maintenance_service: {
            status: 'completed'
          }
        }
        put "/api/v1/maintenance_services/#{service.id}", params: params, headers: valid_token_header(user)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to match_response_schema('errors')
      end
    end

    context 'with discarded maintenance service' do
      it 'should not updates a maintenance service' do
        service.discard
        params = {
          maintenance_service: {
            status: 'in_progress'
          }
        }
        put "/api/v1/maintenance_services/#{service.id}", params: params, headers: valid_token_header(user)

        expect(response).to have_http_status(:not_found)
        expect(response.body).to match_response_schema('errors', strict: true)
      end
    end
  end

  context 'with unauthorized user' do
    context 'with missing token' do
      it 'should not return a list of maintenance services for a vehicle' do
        get "/api/v1/vehicles/#{vehicle.id}/maintenance_services"

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Missing token')
      end

      it 'should not create a maintenance service for a vehicle' do
        post "/api/v1/vehicles/#{vehicle.id}/maintenance_services",
              params: { maintenance_service: attributes_for(:maintenance_service) }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Missing token')
      end

      it 'should not update a maintenance service' do
        params = {
          maintenance_service: {
            status: 'in_progress'
          }
        }
        put "/api/v1/maintenance_services/#{service.id}", params: params

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Missing token')
      end
    end
    context 'with invalid token' do
      it 'should not return a list of maintenance services for a vehicle' do
        get "/api/v1/vehicles/#{vehicle.id}/maintenance_services", headers: invalid_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
      end

      it 'should not create a maintenance service for a vehicle' do
        post "/api/v1/vehicles/#{vehicle.id}/maintenance_services",
              params: { maintenance_service: attributes_for(:maintenance_service) },
              headers: invalid_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
      end

      it 'should not update a maintenance service' do
        params = {
          maintenance_service: {
            status: 'in_progress'
          }
        }
        put "/api/v1/maintenance_services/#{service.id}", params: params, headers: invalid_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
      end
    end
    context 'with expired token' do
      it 'should not return a list of maintenance services for a vehicle' do
        get "/api/v1/vehicles/#{vehicle.id}/maintenance_services", headers: expired_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Sorry, your token has expired. Please login to continue.')
      end

      it 'should not create a maintenance service for a vehicle' do
        post "/api/v1/vehicles/#{vehicle.id}/maintenance_services",
              params: { maintenance_service: attributes_for(:maintenance_service) },
              headers: expired_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Sorry, your token has expired. Please login to continue.')
      end

      it 'should not update a maintenance service' do
        params = {
          maintenance_service: {
            status: 'in_progress'
          }
        }
        put "/api/v1/maintenance_services/#{service.id}", params: params, headers: expired_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Sorry, your token has expired. Please login to continue.')
      end
    end
  end
end
