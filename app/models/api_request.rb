class ApiRequest < ApplicationRecord
  validates :exam_start_time, presence: true
  belongs_to :user
  belongs_to :exam
end
