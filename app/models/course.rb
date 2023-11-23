class Course < ApplicationRecord
    has_one_attached :video
    attribute :video, :string
    has_one_attached :document
    attribute :document, :string
    belongs_to :user
    attr_accessor :stripe_price_id
end
