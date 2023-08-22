class Subscription < ApplicationRecord
  has_many :subscriptions, through: :user_subscriptions
  has_many :user_subscriptions
end
