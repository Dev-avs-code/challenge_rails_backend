class MaintenanceService < ApplicationRecord
  include Discard::Model

  belongs_to :vehicle

  enum :status, { pending: "pending", in_progress: "in_progress", completed: "completed" }, validate: true
  enum :priority, { low: "low", medium: "medium", high: "high" }, validate: true

  validates :description, presence: true
  validates :cost_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :completed_at, presence: true,  comparison: { less_than_or_equal_to: -> { Time.current } }, if: -> { status == "completed" }

  scope :kept, -> { undiscarded.joins(:vehicle).merge(Vehicle.kept) }
  scope :filter_by_status, -> (status) { where(status: status) if status.present? }
  scope :filter_by_priority, -> (priority) { where(priority: priority) if priority.present? }
  scope :search, -> (id) { where(id: id) if id.present? }

  scope :ordered, -> (sort_by = "id", sort_order = "desc") {
    sort_order = %w[asc desc].include?(sort_order.downcase) ? sort_order : "desc"
    order(sort_by => sort_order)
  }

  after_save :update_vehicle_status

  private

  def update_vehicle_status
    vehicle.update_status!
  end
end
