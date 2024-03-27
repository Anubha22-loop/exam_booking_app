class User < ApplicationRecord
  validates :phone_no, length: { is: 10, message: "should be 10 digits long" }
  validates :phone_no, uniqueness: true
  validates :phone_no, presence: true, format: { with: /\A\d+\z/, message: "should contain only numeric characters" }
end
