FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "title_#{n}" } # This allows for many articles to be created at the same time
    content "This is my content"
    user # This requires that a user model to be created (or specified) and associated with the record
  end
end

