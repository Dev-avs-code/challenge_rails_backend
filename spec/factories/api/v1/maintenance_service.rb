FactoryBot.define do
  factory :maintenance_service do
    vehicle factory: :vehicle
    description { Faker::Lorem.sentence }
    status { :pending }
    cost_cents { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    priority { :low }
    completed_at { nil }

    trait :status_in_progress do
      status { :in_progress }
    end

    trait :status_completed do
      status { :completed }
    end

    trait :priority_medium do
      priority { :medium }
    end

    trait :priority_high do
      priority { :high }
    end
  end
end
