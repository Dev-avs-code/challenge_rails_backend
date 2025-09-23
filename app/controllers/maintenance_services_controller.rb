class MaintenanceServicesController < ApplicationController
  before_action :set_vehicle, only: [:index, :new, :create, :edit, :update]
  before_action :set_maintenance_service, only: [:edit, :update]

  def index
    @maintenance_services = @vehicle.maintenance_services
                                    .filter_by_status(params[:status])
                                    .filter_by_priority(params[:priority])
                                    .search(params[:q])
                                    .ordered(params[:sort_by] || 'id', params[:sort_order] || 'desc')
                                    .page(params[:page])
                                    .per(params[:per_page])
  end

  def new
    @maintenance_service = MaintenanceService.new
  end

  def edit
  end

  def create
    @maintenance_service = @vehicle.maintenance_services.new(maintenance_service_params)

    respond_to do |format|
      if @maintenance_service.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            'maintenance_services',
            partial: 'maintenance_services/maintenance_service',
            locals: {
              maintenance_service: @maintenance_service
            }
          )
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @maintenance_service.update(maintenance_service_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "maintenance_service_#{@maintenance_service.id}",
            partial: "maintenance_services/maintenance_service",
            locals: {
              maintenance_service: @maintenance_service
            }
          )
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_maintenance_service
      @maintenance_service = MaintenanceService.kept.find(params[:id])
    end

    def set_vehicle
      @vehicle = Vehicle.kept.find(params[:vehicle_id])
    end

    def maintenance_service_params
      params.require(:maintenance_service).permit(:description, :status, :cost_cents, :priority, :completed_at)
    end
end
