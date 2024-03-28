class ExamWindow < ApplicationRecord
  validates :start_time, :end_time, presence: true
  belongs_to :exam
  validate :end_time_after_start_time

  private

  # Custom validation method to check if end time is after start time
  def end_time_after_start_time
    return unless end_time && start_time

    if end_time <= start_time
      errors.add(:end_time, I18n.t('model.exam_window.errors.invalid_window'))
    end
  end
end
