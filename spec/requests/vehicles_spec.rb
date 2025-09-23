require 'rails_helper'

RSpec.describe VehiclesController, type: :controller do
  let!(:vehicle) { create(:vehicle) }

  it 'GET /vehicles' do
    get :index
    expect(response).to have_http_status(:ok)
  end

  it 'GET /vehicles/new' do
    get :new
    expect(response).to have_http_status(:ok)
  end

  it 'GET /vehicles/:id/edit' do
    get :edit, params: { id: vehicle.id }
    expect(response).to have_http_status(:ok)
  end

  describe 'POST /vehicles' do
    context "with valid params" do
      let(:valid_params) { attributes_for(:vehicle) }

      it 'creates a new vehicle and responds with turbo_stream' do
        expect {
          post :create, params: { vehicle: valid_params }, as: :turbo_stream
        }.to change(Vehicle, :count).by(1)

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { vin: nil, plate: nil } }

      it 'renders errors' do
        post :create, params: { vehicle: invalid_params }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATH /vehicles/:id' do
    context 'with valid params' do
      it 'updates the vehicle and responds with turbo_stream' do
        patch :update, params: { id: vehicle.id, vehicle: { brand: 'new_brand' } }, as: :turbo_stream

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context 'with invalid params' do
      it "renders errors" do
        patch :update, params: { id: vehicle.id, vehicle: { status: 'other' } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /vehicles/:id' do
    it 'removes the vehicle and responds with turbo_stream' do
      expect {
        delete :destroy, params: { id: vehicle.id }, as: :turbo_stream
      }.not_to change(Vehicle, :count)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(Vehicle.with_discarded.find(vehicle.id)).to be_present
    end
  end
end
