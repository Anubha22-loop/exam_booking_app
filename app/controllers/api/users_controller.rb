class Api::UsersController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :missing_param_error
  before_action :validate_params_type
  before_action :validate_college, :validate_exam, :validate_exam_window


  def create

    user = User.find_or_initialize_by(
          first_name: create_params[:first_name],
          last_name: create_params[:last_name],
          phone_no: create_params[:phone_number]
        )
    
    if user.save
      booking = ExamBooking.new(
        user_id: user.id,
        exam_id: create_params[:exam_id],
        exam_start_time: create_params[:start_time].to_datetime
      )
      if booking.save
        render json: { message: I18n.t('controller.api.users.create.success') }, status: :ok
      else
        render json: { error: I18n.t('controller.api.users.create.exam_booking_creation_failure') }, status: :bad_request
      end
    else
      render json: { error: I18n.t('controller.api.users.create.user_creation_failure') }, status: :bad_request
    end
    
  end

  private

  def create_params
    params.permit(
      :first_name,
      :last_name,
      :phone_number,
      :college_id,
      :exam_id,
      :start_time
    ).tap do |whitelisted|
      whitelisted.require(:first_name)
      whitelisted.require(:last_name)
      whitelisted.require(:phone_number)
      whitelisted.require(:college_id)
      whitelisted.require(:exam_id)
      whitelisted.require(:start_time)
    end
  end

  def validate_params_type
    unless create_params[:first_name].is_a?(String) &&
           create_params[:last_name].is_a?(String) &&
           create_params[:phone_number].is_a?(String) &&
           create_params[:college_id].is_a?(Integer) &&
           create_params[:exam_id].is_a?(Integer) &&
           create_params[:start_time].is_a?(String)

      render json: { error: I18n.t('controller.api.users.create.invalid_data_type') }, status: :bad_request
    end
  end

  def missing_param_error
    render json: { error: I18n.t('controller.api.users.create.parameter_missing_error') }, status: :bad_request
  end

  def validate_college
    college = College.find_by(id: create_params[:college_id])
    render json: { error: I18n.t('controller.api.users.create.invalid_college_failure') }, status: :bad_request unless college
  end

  def validate_exam
    exam = Exam.find_by(id: create_params[:exam_id])
    render json: { error: I18n.t('controller.api.users.create.invalid_exam_failure') }, status: :bad_request unless exam && exam.college_id == create_params[:college_id].to_i
  end

  def validate_exam_window
    exam_window = Exam.find_by(id: create_params[:exam_id])&.exam_window
    exam_time_range = exam_window&.start_time..exam_window&.end_time
    render json: { error: I18n.t('controller.api.users.create.invalid_exam_time_failure')}, status: :bad_request unless exam_time_range.cover?(create_params[:start_time].to_datetime)
  end
end
