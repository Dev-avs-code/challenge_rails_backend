class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[ edit update destroy ]

  # GET /vehicles
  def index
    @vehicles = Vehicle.all
                       .filter_by_status(params[:status])
                       .search(params[:q])
                       .ordered(params[:sort_by] || "id", params[:sort_order] || "desc")
                       .page(params[:page])
                       .per(params[:per_page])
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
  end

  # POST /vehicles or /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)

    respond_to do |format|
      if @vehicle.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            'vehicles',
            partial: 'vehicles/vehicle',
            locals: {
              vehicle: @vehicle
            }
          )
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "vehicle_#{@vehicle.id}",
            partial: 'vehicles/vehicle',
            locals: {
              vehicle: @vehicle
            }
          )
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  def destroy
    @vehicle.destroy!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("vehicle_#{@vehicle.id}")
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def vehicle_params
    params.require(:vehicle).permit(:vin, :plate, :brand, :model, :year, :status)
  end
end
