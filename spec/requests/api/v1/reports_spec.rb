require 'rails_helper'

RSpec.describe '/api/v1/reports', type: :request do
  let(:user) { create(:user) }
  let(:vehicle) { create(:vehicle) }
  let(:services) { create_list(:maintenance_service, 5, vehicle: vehicle) }

  let!(:auth_header) do
    post '/api/v1/auth/login', params: { email: user.email, password: user.password }

    expect(response).to have_http_status(:success)
    token = JSON.parse(response.body)["token"]

    { "Authorization" => "Bearer #{token}" }
  end

  it 'returns a maintenance summary report for the given date range' do
    get '/api/v1/reports/maintenance_summary',
        params: { from: 7.days.ago.to_date.to_s, to: Date.today.to_s }, headers: auth_header

    expect(response).to have_http_status(:ok)
    expect(response).to match_response_schema('reports/maintenance_summary')
  end

  context 'request with errors' do
    it 'returns error if from or to is missing' do
      get "/api/v1/reports/maintenance_summary", params: { from: 7.days.ago.to_date.to_s }, headers: auth_header

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to match_response_schema('errors')
    end

    it 'returns an error if the start or end date is more than 90 days away. ' do
      get "/api/v1/reports/maintenance_summary", params: { from: 1.year.ago.to_date.to_s, to: '2025-09-12' }, headers: auth_header

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to match_response_schema('errors')
    end
  end
end
