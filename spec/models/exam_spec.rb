require 'rails_helper'

RSpec.describe Exam, type: :model do
  it { is_expected.to belong_to(:college) }
  it { is_expected.to have_one(:exam_window) }
  it { is_expected.to have_many(:api_requests) }

  it { is_expected.to validate_presence_of(:name) }

end
