vehicles = Vehicle.all

MAINTENANCE_TYPES = [
  "Cambio de aceite",
  "Revisión de frenos",
  "Cambio de llantas",
  "Alineación y balanceo",
  "Servicio eléctrico",
  "Cambio de filtros",
  "Revisión de suspensión",
  "Diagnóstico general"
].freeze

vehicles.each do |vehicle|
  2.times do
    status = vehicle.in_maintenance? ?  %w[pending in_progress].sample : 'completed'
    completed_at = status == 'completed' ? Time.now : nil

    MaintenanceService.find_or_create_by!(
      vehicle: vehicle,
      description: MAINTENANCE_TYPES.sample,
      status: status,
      cost_cents: Faker::Commerce.price(range: 2000..15000),
      priority: MaintenanceService.priorities.keys.sample,
      completed_at: completed_at,
    )
  end
end
