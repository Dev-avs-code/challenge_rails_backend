class Vehicle < ApplicationRecord
  has_many :maintenance_services, dependent: :destroy

  enum :status, { active: "active", inactive: "inactive", in_maintenance: "in_maintenance" }, validate: true

  validates :vin, presence: true, uniqueness: { case_sensitive: false }
  validates :plate, presence: true, uniqueness: { case_sensitive: false }
  validates :brand, presence: true
  validates :model, presence: true
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 1989, less_than_or_equal_to: Date.current.year }

  scope :filter_by_status, -> (status) { where(status: status) if status.present? }

  scope :search, -> (term) {
    term = term.to_s.strip[0, 20]
    return all if term.blank?
    q = "%#{ActiveRecord::Base.sanitize_sql_like(term)}%"
    where("vin ILIKE :q OR plate ILIKE :q", q: q)
  }

  scope :ordered, -> (sort_by = "id", sort_order = "desc") {
    sort_order = %w[asc desc].include?(sort_order.downcase) ? sort_order : "desc"
    order(sort_by => sort_order)
  }

  def update_status!
    if maintenance_services.where(status: [:pending, :in_progress]).exists?
      update!(status: :in_maintenance)
    end
  end
end
