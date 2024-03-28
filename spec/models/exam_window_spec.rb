require 'rails_helper'

RSpec.describe ExamWindow, type: :model do
  it { is_expected.to belong_to(:exam) }
  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }


  describe "validations" do
    it "is valid with valid attributes" do
      exam_window = build(:exam_window)
      expect(exam_window).to be_valid
    end

    it "is invalid when end_time is before start_time" do
      exam_window = build(:exam_window, start_time: DateTime.now, end_time: DateTime.now - 1.hour)
      expect(exam_window).not_to be_valid
      expect(exam_window.errors[:end_time]).to include("must be after the start time")
    end
  end
end
