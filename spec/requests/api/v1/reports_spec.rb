require 'rails_helper'

RSpec.describe '/api/v1/reports', type: :request do
  let(:user) { create(:user) }
  let(:vehicle) { create(:vehicle) }
  let(:services) { create_list(:maintenance_service, 5, vehicle: vehicle) }

  it 'returns a maintenance summary report for the given date range' do
    get '/api/v1/reports/maintenance_summary',
        params: { from: 7.days.ago.to_date.to_s, to: Date.today.to_s }, headers: valid_token_header(user)

    expect(response).to have_http_status(:ok)
    expect(response).to match_response_schema('reports/maintenance_summary')
  end

  context 'with errors' do
    it 'returns error if from or to is missing' do
      get "/api/v1/reports/maintenance_summary", params: { from: 7.days.ago.to_date.to_s }, headers: valid_token_header(user)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to match_response_schema('errors')
    end

    it 'returns an error if the start or end date is more than 90 days away. ' do
      get "/api/v1/reports/maintenance_summary", params: { from: 1.year.ago.to_date.to_s, to: '2025-09-12' }, headers: valid_token_header(user)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to match_response_schema('errors')
    end
  end

  context 'with unauthorized user' do
    context 'with missing token' do
      it 'should not return a maintenance summary' do
        get '/api/v1/reports/maintenance_summary', params: { from: 7.days.ago.to_date.to_s, to: Date.today.to_s }

        expect(response).to have_http_status(:unauthorized)
        expect(response).to match_response_schema('errors')
        expect(response.body).to include('Missing token')
      end
    end
    context 'with invalid token' do
      it 'should not return a maintenance summary' do
        get '/api/v1/reports/maintenance_summary',
            params: { from: 7.days.ago.to_date.to_s, to: Date.today.to_s }, headers: invalid_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
      end
    end
    context 'with expired token' do
      it 'should not return a maintenance summary' do
        get '/api/v1/reports/maintenance_summary',
            params: { from: 7.days.ago.to_date.to_s, to: Date.today.to_s }, headers: expired_token_header(user)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to match_response_schema('errors', strict: true)
        expect(response.body).to include('Sorry, your token has expired. Please login to continue.')
      end
    end
  end
end
