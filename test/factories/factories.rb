FactoryBot.define do
  factory :day do
    date { '2017-05-10' }

    factory :day_with_food do
      after(:create) do |day|
        create(:blueberries, day: day)
        create(:soymilk, day: day)
        create(:fireweed, day: day)
        create(:raisinbran, day: day)
      end
    end
  end

  factory :soymilk, class: Food do
    ndbno { 16_235 }
    amount { 1 }
    measure { 'cup' }
  end

  factory :raisinbran, class: Food do
    ndbno { 8061 }
    amount { 1 }
    measure { 'cup (1 NLEA serving)' }
  end

  factory :blueberries, class: Food do
    ndbno { 9050 }
    amount { 1 }
    measure { 'cup' }
  end

  factory :fireweed, class: Food do
    ndbno { 35_038 }
    amount { 1 }
    measure { 'cup, chopped' }
  end
end
