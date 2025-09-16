module Api
  module V1
    class MaintenanceServicesController < ApiApplicationController
      before_action :set_vehicle, only: [:index, :create]
      before_action :set_maintenance_service, only: [:update]

      # GET /api/v1/vehicles/:vehicle_id/maintenance_services
      def index
        services = @vehicle.maintenance_services
                           .filter_by_status(params[:status])
                           .filter_by_priority(params[:priority])
                           .search(params[:q])
                           .ordered(params[:sort_by] || "id", params[:sort_order] || "desc")
                           .page(params[:page])
                           .per(params[:per_page])

        render json: services, meta: pagination(services)
      end

      # POST /api/v1/vehicles/:vehicle_id/maintenance_services
      def create
        service = @vehicle.maintenance_services.create!(maintenance_service_params)
        render json: service, status: :created
      end

      # PATCH/PUT /api/v1/maintenance_services/:id
      def update
        @maintenance_service.update!(maintenance_service_params)
        render json: @maintenance_service
      end

      private

      def set_maintenance_service
        @maintenance_service = MaintenanceService.find(params[:id])
      end

      def set_vehicle
        @vehicle = Vehicle.find(params[:vehicle_id])
      end

      def maintenance_service_params
        params.require(:maintenance_service).permit(:description, :status, :cost_cents, :priority, :completed_at)
      end
    end
  end
end
