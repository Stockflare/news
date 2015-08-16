FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| n.to_s + Faker::Internet.email }

    password Faker::Internet.password(8, 20)

    otp { rand(123456..234567) }

    initialize_with { User.new attributes }
  end
end
