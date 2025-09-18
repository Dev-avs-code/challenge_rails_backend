require 'rails_helper'

RSpec.describe MaintenanceService, type: :model do
  it 'requires completed_at to be present' do
    service = build(:maintenance_service, status: :completed, completed_at: 3.days.from_now)
    expect(service).not_to be_valid
  end
end
