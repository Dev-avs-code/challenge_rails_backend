class ReportParamsValidator
  include ActiveModel::Model

  attr_accessor :from, :to

  validates :from, :to, presence: true
  validate :valid_date_format
  validate :date_range_within_limit

  private

  def valid_date_format
    %i[from to].each do |field|
      value = send(field)
      next if value.blank?

      begin
        Date.parse(value.to_s)
      rescue ArgumentError
        errors.add(field, 'Invalid format date')
      end
    end
  end

  def date_range_within_limit
    return if errors.any?

    from_date = Date.parse(from.to_s)
    to_date   = Date.parse(to.to_s)

    if to_date < from_date
      errors.add(:to, "can not be earlier than the 'from' date")
    elsif (to_date - from_date).to_i > 90
      errors.add(:base, 'The date range can not exceed 90 days.')
    end
  end
end
