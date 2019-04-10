FactoryBot.define do
  factory :comment do
    sequence(:message) { |n| "message_#{n}" }
    article
    user
  end
end
