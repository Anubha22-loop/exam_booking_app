require 'rails_helper'

RSpec.describe Api::ExamWindowsController, type: :controller do
  describe "POST /create" do
    context 'With valid request' do
      let(:exam) { create(:exam) }
      let(:request) {
        {
          :exam_start_time => '2022-01-01T10:00:00',
          :exam_end_time => '2022-01-02T10:00:00',
          :exam_id => exam.id
        }
      }

      it 'should give status code 200 and successful message' do
        post :create, params: request, as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("Exam Window created successfully")
      end

      it 'should increase the count of exam by one' do
        expect { post :create, params: request, as: :json }.to change{ ExamWindow.count }.by(1)
        exam_window = ExamWindow.last
        expect(exam_window.id).to eq(request[:exam_id])
      end
    end

    context 'with invalid request' do
      it 'gives bad request if one of the parameters are missing' do
        request = { :exam_start_time => '2022-01-01T10:00:00', :exam_end_time => '2022-01-02T10:00:00' }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to include("param is missing or the value is empty")
      end

      it 'gives bad request if datatype for any params is incorrect' do
        request = { :exam_start_time => '2022-01-01T10:00:00', :exam_end_time => '2022-01-02T10:00:00', :exam_id => 'abc' }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Invalid data types for one or more params")
      end

      it 'gives bad request if exam doesnot exist for the given exam_id' do
        request = {
            :exam_start_time => '2022-01-01T10:00:00',
            :exam_end_time => '2022-01-02T10:00:00',
            :exam_id => 5
          }
          post :create, params: request, as: :json
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)['error']).to eq("Exam with the given ID not found")
      end

      it 'gives bad request if date is send as aplha numeric creation fails' do
        exam = create(:exam)
        allow_any_instance_of(ExamWindow).to receive(:save).and_return(false)
        request = {
          :exam_start_time => '2022-01-01T10:00:00',
          :exam_end_time => 'abc',
          :exam_id => exam.id
        }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("invalid date")
      end

      it 'gives bad request if Exam Window creation fails' do
        exam = create(:exam)
        allow_any_instance_of(ExamWindow).to receive(:save).and_return(false)
        request = {
          :exam_start_time => '2022-01-01T10:00:00',
          :exam_end_time => '2022-01-02T10:00:00',
          :exam_id => exam.id
        }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Failed to create Examination Window")
      end
    end
  end
end