FactoryBot.define do
  factory :exam_window do
    start_time { '2022-01-01T08:00:00'.to_datetime }
    end_time { '2022-01-01T20:00:00'.to_datetime }
    exam { create(:exam) }
  end
end