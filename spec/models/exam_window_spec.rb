require 'rails_helper'

RSpec.describe ExamWindow, type: :model do
  it { is_expected.to belong_to(:exam) }
  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }
end
