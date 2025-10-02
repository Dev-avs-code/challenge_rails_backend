module Api
  module V1
    class VehiclesController < ApiApplicationController
      before_action :set_vehicle, only: [:show, :update, :destroy]

      # GET /api/v1/vehicles
      def index
        vehicles = Vehicle.kept
                          .filter_by_status(params[:status])
                          .search(params[:q])
                          .ordered(params[:sort_by] || "id", params[:sort_order] || "desc")
                          .page(params[:page])
                          .per(params[:per_page])

        render json: vehicles
      end

      # GET /api/v1/vehicles/:id
      def show
        render json: @vehicle
      end

      # POST /api/v1/vehicles
      def create
        vehicle = Vehicle.create!(vehicle_params)
        render json: vehicle, status: :created
      end

      # PUT/PATCH /api/v1/vehicles/:id
      def update
        @vehicle.update!(vehicle_params)
        render json: @vehicle
      end

      # DELETE /api/v1/vehicles/:id
      def destroy
        @vehicle.discard!
        head :no_content
      end

      private

      def set_vehicle
        @vehicle = Vehicle.kept.find(params[:id])
      end

      def vehicle_params
        params.permit(:vin, :plate, :brand, :model, :year, :status)
      end
    end
  end
end
