class Course < ApplicationRecord
    has_one_attached :video
    has_one_attached :document
end
