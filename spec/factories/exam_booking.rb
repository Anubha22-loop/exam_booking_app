FactoryBot.define do
  factory :exam_booking do
    exam_start_time { '2022-01-01T08:00:00'.to_datetime }
    user { create(:user) }
    exam { create(:exam) }
  end
end