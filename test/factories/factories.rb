FactoryBot.define do

  factory :user do
    email                 {"shmoe@example.com"}
    password              {"secret"}
  end

  factory :day do
    user
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
     fdcid { 175218 }
    amount { 1 }
    measure { 'cup' }
  end

  factory :raisinbran, class: Food do
    fdcid { 171650 } # Cereals ready-to-eat, POST Raisin Bran Cereal (SR legacy)
    amount { 1 }
    measure { 'cup (1 NLEA serving)' }
  end

  factory :blueberries, class: Food do
    fdcid { 171711 }
    amount { 1 }
    measure { 'cup' }
  end

  factory :fireweed, class: Food do
    fdcid {  169399 }
    amount { 1 }
    measure { 'cup, chopped' }
  end
end

def user_with_days(days_count: 1)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:day, days_count, user: user)
  end
end
