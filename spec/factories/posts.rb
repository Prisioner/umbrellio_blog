FactoryBot.define do
  factory :post do
    title Faker::Lorem.sentence
    body Faker::Lorem.paragraphs(5).join('\n')
    ip Faker::Internet.ip_v4_address
    rating 5.0
    username Faker::Internet.unique.user_name

    association :user
  end
end
