class Api::ExamWindowsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :missing_param_error
  before_action :validate_exam

  def create
    exam_window = ExamWindow.new(
      start_time: create_params[:exam_start_time].to_datetime,
      end_time: create_params[:exam_end_time].to_datetime,
      exam_id: create_params[:exam_id]
    )

    if exam_window.save
      render json: { message: I18n.t('controller.api.exam_windows.create.success') }, status: :ok
    else
      render json: { error: I18n.t('controller.api.exam_windows.create.exam_window_creation_failure') }, status: :bad_request
    end
  end

  private

  def create_params
    params.permit(
      :exam_start_time,
      :exam_end_time,
      :exam_id
    ).tap do |whitelisted|
      whitelisted.require(:exam_start_time)
      whitelisted.require(:exam_end_time)
      whitelisted.require(:exam_id)
    end
  end

  def validate_exam
    exam = Exam.find_by(id: create_params[:exam_id])
    render json: { error: I18n.t('controller.api.exam_windows.create.invalid_exam_failure') }, status: :bad_request unless exam
  end

  def missing_param_error
    render json: { error: I18n.t('controller.api.exam_windows.create.paramete_missing_error') }, status: :bad_request
  end
end
