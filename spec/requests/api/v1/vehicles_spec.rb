require 'rails_helper'

RSpec.describe 'vehicles', type: :request do
  let(:user) { create(:user) }
  let(:vehicles) { create_list(:vehicle, 5) }
  let(:vehicle) { create(:vehicle) }

  context 'with authorized user' do
    it 'should return a list of vehicles' do
      get "/api/v1/vehicles", headers: valid_token_header(user)

      expect(response).to have_http_status(:ok)
      expect(response.body).to match_response_schema('vehicles/index', strict: true)
    end

    it 'should return a single vehicle' do
      get "/api/v1/vehicles/#{vehicle.id}", headers: valid_token_header(user)

      expect(response).to have_http_status(:ok)
      expect(response.body).to match_response_schema('vehicles/show', strict: true)
    end

    context 'with valid params' do
      it 'should create a new vehicle' do
        post '/api/v1/vehicles', params: { vehicle: attributes_for(:vehicle) }, headers: valid_token_header(user)

        expect(response).to have_http_status(:created)
        expect(response.body).to match_response_schema('vehicles/show', strict: true)
      end

      it 'should updates a vehicle' do
        params = {
          vehicle: {
            status: 'inactive'
          }
        }
        put "/api/v1/vehicles/#{vehicle.id}", params: params, headers: valid_token_header(user)

        expect(response).to have_http_status(:ok)
        expect(response.body).to match_response_schema('vehicles/show', strict: true)
      end

      it 'should delete a vehicle' do
        delete "/api/v1/vehicles/#{vehicle.id}", headers: valid_token_header(user)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with invalid params' do
      it 'should not create a new vehicle' do
        params = {
          vehicle: {
            brand: 'Mercedes-Benz',
            model: 'Serie 300'
          }
        }
        post '/api/v1/vehicles', params: params, headers: valid_token_header(user)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to match_response_schema('errors', strict: true)
      end

      it 'should not update a vehicle' do
        params = {
          vehicle: {
            status: 'other'
          }
        }
        put "/api/v1/vehicles/#{vehicle.id}", params: params, headers: valid_token_header(user)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to match_response_schema('errors', strict: true)
      end
    end
  end

  context 'with unauthorized user' do
    context 'with missing token' do
      it 'should not return a list vehicles' do
        get '/api/v1/vehicles'

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Missing token')
      end

      it 'should not return a vehicle' do
        get "/api/v1/vehicles/#{vehicle.id}"

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Missing token')
      end

      it 'should not create vehicle' do
        post '/api/v1/vehicles', params: { vehicle: attributes_for(:vehicle) }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Missing token')
      end

      it 'should not update a vehicle' do
        params = {
          vehicle: {
            status: 'inactive'
          }
        }
        put "/api/v1/vehicles/#{vehicle.id}", params: params

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Missing token')
      end

      it 'should not delete a vehicle' do
        delete "/api/v1/vehicles/#{vehicle.id}"

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Missing token')
      end
    end

    context 'with invalid token' do
      it 'should not return a list vehicles' do
        get '/api/v1/vehicles', headers: invalid_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
      end

      it 'should not return a vehicle' do
        get "/api/v1/vehicles/#{vehicle.id}", headers: invalid_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
      end

      it 'should not create a vehicle' do
        post '/api/v1/vehicles', params: { vehicle: attributes_for(:vehicle) }, headers: invalid_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
      end

      it 'should not update a vehicle' do
        params = {
          vehicle: {
            status: 'inactive'
          }
        }
        put "/api/v1/vehicles/#{vehicle.id}", params: params, headers: invalid_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
      end

      it 'should not delete a vehicle' do
        delete "/api/v1/vehicles/#{vehicle.id}", headers: invalid_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
      end
    end

    context 'with expired token' do
      it 'should not return a list vehicles' do
        get '/api/v1/vehicles', headers: expired_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Sorry, your token has expired. Please login to continue.')
      end

      it 'should not return a vehicle' do
        get "/api/v1/vehicles/#{vehicle.id}", headers: expired_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Sorry, your token has expired. Please login to continue.')
      end

      it 'should not create a vehicle' do
        post '/api/v1/vehicles', params: { vehicle: attributes_for(:vehicle) }, headers: expired_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Sorry, your token has expired. Please login to continue.')
      end

      it 'should not update a vehicle' do
        params = {
          vehicle: {
            status: 'inactive'
          }
        }
        put "/api/v1/vehicles/#{vehicle.id}", params: params, headers: expired_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Sorry, your token has expired. Please login to continue.')
      end

      it 'should not delete a vehicle' do
        delete "/api/v1/vehicles/#{vehicle.id}", headers: expired_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Sorry, your token has expired. Please login to continue.')
      end
    end
  end
end
