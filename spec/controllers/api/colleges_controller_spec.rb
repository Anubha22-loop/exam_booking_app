require 'rails_helper'

RSpec.describe Api::CollegesController, type: :controller do
  describe "POST /create" do
    context 'With valid request' do
      let(:request) {
        {
          :college_name => 'random college'
        }
      }

      it 'should give status code 200 and successful message' do
        post :create, params: request, as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("College created successfully")
      end

      it 'should increase the count of exam by one' do
        expect { post :create, params: request, as: :json }.to change{ College.count }.by(1)
        college = College.last
        expect(college.name).to eq(request[:college_name])
      end
    end

    context 'with invalid request' do
      it 'gives bad request if one of the parameters are missing' do
        request = { }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to include("param is missing or the value is empty")
      end

      it 'gives bad request if datatype for params are incorrect' do
        request = { :college_name => 1 }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Invalid data types for one or more params")
      end

      it 'gives bad request if user creation fails' do
        allow_any_instance_of(College).to receive(:save).and_return(false)
        request = 
          {
            :college_name => 'random college'
          }
        post :create, params: request, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq("Failed to create College")
      end
    end
  end
end