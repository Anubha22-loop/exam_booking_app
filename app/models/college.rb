class College < ApplicationRecord
  validates :name, presence: true
  has_many :exams
end
