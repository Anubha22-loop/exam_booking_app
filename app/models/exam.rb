class Exam < ApplicationRecord
  belongs_to :college
  has_one :exam_window
  has_many :exam_bookings

  validates :name, presence: true
end
