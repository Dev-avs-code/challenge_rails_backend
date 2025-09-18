FactoryBot.define do
  factory :vehicle do
    vin { Faker::Vehicle.unique.vin }
    plate { Faker::Vehicle.unique.license_plate }
    brand { Faker::Vehicle.make }
    model { Faker::Vehicle.model }
    year { Faker::Vehicle.year }
    status { :active }

    trait :in_maintenance do
      status { :in_maintenance }
    end

    trait :inactive do
      status { :inactive }
    end
  end
end
