class Api::ExamWindowsController < ApplicationController
  before_action :validate_params_type, :validate_exam

  def create
    exam_window = ExamWindow.new(
      start_time: create_params[:exam_start_time].to_datetime,
      end_time: create_params[:exam_end_time].to_datetime,
      exam_id: create_params[:exam_id]
    )

    if exam_window.save
      render json: { message: I18n.t('controller.api.exam_windows.create.success') }, status: :ok
    else
      raise Errors::BadRequestError.new(I18n.t('controller.api.exam_windows.create.exam_window_creation_failure'))
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

  def validate_params_type
    unless create_params[:exam_start_time].is_a?(String)  &&  create_params[:exam_end_time].is_a?(String) && create_params[:exam_id].is_a?(Integer)
      raise Errors::BadRequestError.new(I18n.t('controller.api.exam_windows.create.invalid_data_type'))
    end
  end

  def validate_exam
    exam = Exam.find_by(id: create_params[:exam_id])
    unless exam
      raise Errors::BadRequestError.new(I18n.t('controller.api.exam_windows.create.invalid_exam_failure'))
    end
  end
end
