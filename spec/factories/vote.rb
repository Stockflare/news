FactoryGirl.define do
  factory :vote, class: Votes::Vote do
    id Faker::Internet.slug(nil, '-')

    attitude { [0, 1].sample }

    created_at { Time.now.utc }

    initialize_with { Votes::Vote.new attributes }
  end
end
