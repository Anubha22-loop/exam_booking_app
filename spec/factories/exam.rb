FactoryBot.define do
  factory :exam do
    name { 'exam_1' }
    college { create(:college) }
  end
end
