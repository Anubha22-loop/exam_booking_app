require 'rails_helper'

RSpec.describe ExamBooking, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:exam) }

  it { is_expected.to validate_presence_of(:exam_start_time) }


  it "is invalid with duplicate user_id and exam_id" do
    existing_booking = create(:exam_booking)
    duplicate_booking = build(:exam_booking, user_id: existing_booking.user_id, exam_id: existing_booking.exam_id)

    expect(duplicate_booking).not_to be_valid
    expect(duplicate_booking.errors[:user_id]).to include("has already booked this exam")
  end
end
