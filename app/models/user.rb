class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :phone_no, length: { is: 10, message: I18n.t('model.user.errors.invalid_phone_number_length') }
  validates :phone_no, uniqueness: true
  validates :phone_no, presence: true, format: { with: /\A\d+\z/, message: I18n.t('model.user.errors.invalid_phone_number') }

  has_many :api_requests
end
