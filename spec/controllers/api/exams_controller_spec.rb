require 'rails_helper'

RSpec.describe Api::ExamsController, type: :controller do
  describe "POST /create" do
    context 'With valid request' do
      let(:college) { create(:college) }
      let(:request) {
        {
          :exam_name => 'test1',
          :college_id => college.id
        }
      }

      it 'should give status code 200 and successful message' do
        post :create, params: request
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("Exam created successfully")
      end

      it 'should increase the count of exam by one' do
        expect { post :create, params: request }.to change{ Exam.count }.by(1)
        exam = Exam.last
        expect(exam.name).to eq(request[:exam_name])
      end
    end

    context 'with invalid request' do
      it 'gives bad request if one of the parameters are missing' do
        request = { :exam_name => 'test' }
        post :create, params: request
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Required parameter are missing")
      end

      it 'gives bad request if college doesnot exist for the given college_id in api request' do
        request = 
          {
            :exam_name => 'test1',
            :college_id => 4
          }
          post :create, params: request
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("College with the given ID not found")
      end

      it 'gives bad request if user creation fails' do
        college = create(:college)
        allow_any_instance_of(Exam).to receive(:save).and_return(false)
        request = 
          {
            :exam_name => 'test1',
            :college_id => college.id,
          }
          post :create, params: request
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Failed to create exam")
      end
    end
  end
end