class MaintenanceServiceSerializer < ActiveModel::Serializer
  attributes :id, :description, :status, :cost_cents, :priority, :completed_at, :created_at, :updated_at
end
