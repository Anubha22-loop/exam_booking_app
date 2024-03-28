class ExamBooking < ApplicationRecord
  validates :exam_start_time, presence: true
  belongs_to :user
  belongs_to :exam

  validates :user_id, uniqueness: { scope: :exam_id, message: I18n.t('model.exam_booking.errors.invalid_user_and_exam') }
end
