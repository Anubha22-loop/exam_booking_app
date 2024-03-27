require 'rails_helper'

RSpec.describe ApiRequest, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:exam) }

  it { is_expected.to validate_presence_of(:exam_start_time) }
end
