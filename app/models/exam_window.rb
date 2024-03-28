class ExamWindow < ApplicationRecord
  validates :start_time, :end_time, presence: true
  belongs_to :exam
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return unless end_time && start_time

    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end
end
