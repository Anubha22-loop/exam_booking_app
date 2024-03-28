class Api::ExamsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :missing_param_error
  before_action :validate_params_type, :validate_college

  def create
    exam = Exam.new(
      name: create_params[:exam_name],
      college_id: create_params[:college_id]
    )

    if exam.save
      render json: { message: I18n.t('controller.api.exams.create.success') }, status: :ok
    else
      raise Errors::BadRequestError.new(I18n.t('controller.api.exams.create.exam_creation_failure'))
    end
  end

  private

  def create_params
    params.permit(
      :exam_name,
      :college_id
    ).tap do |whitelisted|
      whitelisted.require(:exam_name)
      whitelisted.require(:college_id)
    end
  end

  def validate_params_type
    unless create_params[:exam_name].is_a?(String) && create_params[:college_id].is_a?(Integer)
      raise Errors::BadRequestError.new(I18n.t('controller.api.exams.create.invalid_data_type'))
    end
  end

  def validate_college
    college = College.find_by(id: create_params[:college_id])
    unless college
      raise Errors::BadRequestError.new(I18n.t('controller.api.exams.create.invalid_college_failure'))
    end
  end

  def missing_param_error
    render json: { error: I18n.t('controller.api.exams.create.parameter_missing_error') }, status: :bad_request
  end
end
