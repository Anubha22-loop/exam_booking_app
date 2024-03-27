class Exam < ApplicationRecord
  belongs_to :college
  has_one :exam_window
  has_many :api_requests

  validates :name, presence: true
end
