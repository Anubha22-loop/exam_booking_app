require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:phone_no) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to have_many(:api_requests) }

  describe 'validate unqiueness' do
    subject { build(:user) }

    it { is_expected.to validate_uniqueness_of(:phone_no).case_insensitive }
  end

  describe 'validations' do
    it 'is valid with a 10-digit phone number' do
      user = build(:user, phone_no: '1234567890')
      expect(user).to be_valid
    end

    it 'is invalid with a phone number less than 10 digits' do
      user = build(:user, phone_no: '123456789')
      expect(user).not_to be_valid
      expect(user.errors[:phone_no]).to include("should be 10 digits long")
    end

    it 'is invalid with a phone number more than 10 digits' do
      user = build(:user, phone_no: '12345678901')
      expect(user).not_to be_valid
      expect(user.errors[:phone_no]).to include("should be 10 digits long")
    end

    it 'is invalid with a non-numeric phone number' do
      user = build(:user, phone_no: 'abcdefg123')
      expect(user).not_to be_valid
      expect(user.errors[:phone_no]).to include("should contain only numeric characters")
    end
  end

end
