require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /api/v1/users' do
    it 'should create a new user' do
      post '/api/v1/users', params: attributes_for(:user)

      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema('auth/login')
    end

    it 'returns error when email is missing' do
      post '/api/v1/users', params: attributes_for(:user, email: nil)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to match_response_schema('errors')
    end
  end
end
