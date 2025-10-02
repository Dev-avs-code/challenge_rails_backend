# frozen_string_literal: true

module Reports
  class MaintenanceSummary < Patterns::Service
    attr_reader :error

    def initialize(from:, to:)
      @from = from.presence || Date.today.beginning_of_month
      @to   = to.presence   || Date.today.end_of_month
      @services = MaintenanceService.includes(:vehicle).where(created_at: @from..@to)
    end

    def call
      {
        data: {
          statuses: get_count_by_status,
          vehicles: get_services_by_vehicle,
          top_vehicles_by_cost: get_top_vehicles,
          summary: get_summary
        },
        meta: {
          from: @from,
          to: @to,
          generated_at: Time.current
        }
      }
    end

    private

    def get_count_by_status
      @services.group(:status).pluck(:status, Arel.sql('COUNT(*)')).map do |status, count|
        { status: status, count: count }
      end
    end

    def get_services_by_vehicle
      rows = @services.select('vehicle_id, status, COUNT(*) as count, SUM(cost_cents) as total_cost')
                      .group(:vehicle_id, :status)

      vehicles = rows.group_by(&:vehicle_id)

      vehicles.map do |vehicle_id, services|
        vehicle = services.first.vehicle
        {
          vehicle_id: vehicle.id,
          vin: vehicle.vin,
          plate: vehicle.plate,
          status_breakdown: services.each_with_object({}) { |r, h| h[r.status] = r.count },
          total_services: services.sum { |r| r.count },
          total_cost_cents: services.sum { |r| r.total_cost }
        }
      end
    end

    def get_top_vehicles
      top_3 = @services.select('vehicle_id, SUM(cost_cents) AS total_cost')
                       .group(:vehicle_id)
                       .order("total_cost DESC")
                       .limit(3)
      top_3.map do |v|
        {
          vehicle_id: v[:vehicle_id],
          total_cost_cents: v[:total_cost]
        }
      end
    end

    def get_summary
      {
        total_services: @services.count,
        total_cost_cents: @services.sum(:cost_cents)
      }
    end
  end
end
