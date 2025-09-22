require 'rails_helper'

RSpec.describe '/api/v1/auth', type: :request do
  let!(:user) { create(:user) }

  it 'user login successful' do
    post '/api/v1/auth/login', params: { email: user.email, password: user.password}

    expect(response).to have_http_status(:accepted)
    expect(response).to match_response_schema('auth/login')
  end

  context 'unauthorized user' do
    it 'login with incorrect paswword' do
      post '/api/v1/auth/login', params: { email: user.email, password: 'other_passwrod'}

      expect(response).to have_http_status(:unauthorized)
      expect(response).to match_response_schema('errors')
    end

    it 'login without paswword' do
      post '/api/v1/auth/login', params: { email: user.email }

      expect(response).to have_http_status(:unauthorized)
      expect(response).to match_response_schema('errors')
    end
  end
end
