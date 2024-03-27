require 'rails_helper'

RSpec.describe College, type: :model do
  it { is_expected.to have_many(:exams) }
  it { is_expected.to validate_presence_of(:name) }
end
