FactoryGirl.define do
  factory :token do

    access_token Faker::Bitcoin.address

    refresh_token Faker::Bitcoin.address

    token_type 'bearer'

    expires_in { 1.hour }

    initialize_with { Token.new attributes }
  end
end
