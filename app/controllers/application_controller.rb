class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  rescue_from Errors::BadRequestError, with: :handle_bad_request
  rescue_from ActionController::ParameterMissing, with: :handle_bad_request

  private

  def handle_bad_request(exception)
    render json: { error: exception }, status: :bad_request
  end
end
