class User < ApplicationRecord
  validates :first_name, :last_name, presence: true

  # Validation: Ensure that phone number is exactly 10 characters long
  validates :phone_no, length: { is: 10, message: I18n.t('model.user.errors.invalid_phone_number_length') }
  validates :phone_no, uniqueness: true

  # Validation: Ensure that phone number contains only digits
  validates :phone_no, presence: true, format: { with: /\A\d+\z/, message: I18n.t('model.user.errors.invalid_phone_number') }

  has_many :exam_bookings
end
