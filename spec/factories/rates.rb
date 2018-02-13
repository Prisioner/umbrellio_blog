FactoryBot.define do
  factory :rate do
    rate rand(1..5)

    association :post
  end
end
