BRANDS_MODELS = {
  "Freightliner" => ["Cascadia", "M2 106", "Columbia"],
  "Kenworth"     => ["T680", "T800", "W900"],
  "International"=> ["ProStar", "Durastar", "LT Series"],
  "Volvo"        => ["VNL", "FMX", "FH16"],
  "Mercedes-Benz"=> ["Atego", "Actros", "Accelo"],
  "Isuzu"        => ["ELF 400", "Forward 1100", "NQR"],
  "Hino"         => ["300 Series", "500 Series", "700 Series"]
}.freeze


5.times do
  brand = BRANDS_MODELS.keys.sample

  Vehicle.find_or_create_by!(
    vin: Faker::Vehicle.unique.vin,
    plate: Faker::Vehicle.unique.license_plate,
    brand: brand,
    model: BRANDS_MODELS[brand].sample,
    year: rand(1990..2017),
    status: %w[active in_maintenance].sample
  )
end
