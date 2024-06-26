require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  describe "POST /create" do
    let(:college) { create(:college) }
    let(:exam) { create(:exam, college: college)}
    let!(:exam_window) { create(:exam_window, exam: exam)}

    context 'With valid request' do
      it 'should give status code 200 and successful message' do
        api_request = {
            :first_name => 'test',
            :last_name => 'user',
            :phone_number => '1234567890',
            :college_id => college.id,
            :exam_id => exam.id,
            :start_time => '2022-01-01T10:00:00'
          }
        post :create, params: api_request, as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("User created successfully")
      end

      it 'should create user if not exist' do
        api_request = {
            :first_name => 'test',
            :last_name => 'user',
            :phone_number => '1234567890',
            :college_id => college.id,
            :exam_id => exam.id,
            :start_time => '2022-01-01T10:00:00'
          }
        expect { post :create, params: api_request, as: :json }.to change{ User.count }.by(1)
        user = User.last
        expect(user.phone_no).to eq(api_request[:phone_number])
      end

      it 'should increase the count of create api_request by one' do
        api_request = {
            :first_name => 'test',
            :last_name => 'user',
            :phone_number => '1234567890',
            :college_id => college.id,
            :exam_id => exam.id,
            :start_time => '2022-01-01T10:00:00'
          }
        expect { post :create, params: api_request, as: :json }.to change{ ExamBooking.count }.by(1)
        booking = ExamBooking.last
        expect(booking.exam_start_time).to eq(api_request[:start_time].to_datetime)
      end

      it 'should not create user if already exist' do
        api_request = {
            :first_name => 'test',
            :last_name => 'user',
            :phone_number => '1234567890',
            :college_id => college.id,
            :exam_id => exam.id,
            :start_time => '2022-01-01T10:00:00'
          }
        user = User.create(first_name: api_request[:first_name], last_name: api_request[:last_name], phone_no: api_request[:phone_number])
        expect { post :create, params: api_request, as: :json }.not_to change{ User.count }
        booking = ExamBooking.last
        expect(booking.exam_start_time).to eq(api_request[:start_time].to_datetime)
      end
    end

    context 'With invalid request' do
      it 'gives bad request if one of the parameters are missing' do
        request = { :first_name => 'test', :last_name => 'user'}
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to include("param is missing or the value is empty")
      end

      it 'gives bad request name is blank' do
        request = {
          :first_name => '',
          :last_name => 'user',
          :phone_number => '1234567890',
          :college_id => college.id,
          :exam_id => exam.id,
          :start_time => '2022-01-01T10:00:00'
        }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to include("param is missing or the value is empty")
      end

      it 'gives bad request if it send invalid datatype' do
        request = {
          :first_name => 'test',
          :last_name => 'user',
          :phone_number => '1234567890',
          :college_id => college.id.to_s,
          :exam_id => exam.id,
          :start_time => '2022-01-01T10:00:00'
        }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Invalid data types for one or more params")
      end

      it 'gives bad request if college doesnot exist for the given college_id in api request' do
        request = 
          {
            :first_name => 'test',
            :last_name => 'user',
            :phone_number => '1234567890',
            :college_id => 4,
            :exam_id => exam.id,
            :start_time => '2022-01-01T10:00:00'
          }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("College with the given ID not found")
      end
      it 'gives bad request if exam doesnot exist for the given exam id' do
        request = 
          {
            :first_name => 'test',
            :last_name => 'user',
            :phone_number => '1234567890',
            :college_id => college.id,
            :exam_id => 6,
            :start_time => '2022-01-01T10:00:00'
          }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Exam with the given ID not found or does not belong to the College")
      end
      it 'gives bad request if exam requested is not associated with the asked college' do
        exam1 = create(:exam)
        request = 
        {
          :first_name => 'test',
          :last_name => 'user',
          :phone_number => '1234567890',
          :college_id => college.id,
          :exam_id => exam1.id,
          :start_time => '2022-01-01T10:00:00'
        }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Exam with the given ID not found or does not belong to the College")
      end
      it 'gives bad request if user creation fails' do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        request = 
          {
            :first_name => 'test',
            :last_name => 'user',
            :phone_number => '1234567890',
            :college_id => college.id,
            :exam_id => exam.id,
            :start_time => '2022-01-01T10:00:00'
          }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Failed to create user")
      end
      it 'gives bad request if exam cannot be associated with user' do
        allow_any_instance_of(ExamBooking).to receive(:save).and_return(false)
        request = 
          {
            :first_name => 'test',
            :last_name => 'user',
            :phone_number => '1234567890',
            :college_id => college.id,
            :exam_id => exam.id,
            :start_time => '2022-01-01T10:00:00'
          }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Failed to associate User with the Exam")
      end
      it 'gives bad request if exam start time doesnot falls withing exam time window' do
        request = 
          {
            :first_name => 'test',
            :last_name => 'user',
            :phone_number => '1234567890',
            :college_id => college.id,
            :exam_id => exam.id,
            :start_time => '2022-02-01T10:00:00'
          }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Requested start time does not fall within the Exam's time window")
      end
    end
  end
end
