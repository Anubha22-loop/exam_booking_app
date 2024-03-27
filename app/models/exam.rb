class Exam < ApplicationRecord
  belongs_to :college
  has_many :exam_windows
  has_many :api_requests

  validates :name, presence: true
end
