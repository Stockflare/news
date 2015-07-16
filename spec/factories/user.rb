require 'faker'

FactoryGirl.define do

  factory :user do

    access_token Faker::Bitcoin.address

    refresh_token Faker::Bitcoin.address

    token_type "Bearer"

    expires_at Time.now + 1.hour

    expires_in 1.hour

  end

end
