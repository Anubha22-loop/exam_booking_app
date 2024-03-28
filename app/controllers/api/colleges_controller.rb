class Api::CollegesController < ApplicationController
  before_action :validate_params_type

  def create
    college = College.new(
      name: create_params[:college_name]
    )

    if college.save
      render json: { message: I18n.t('controller.api.colleges.create.success') }, status: :ok
    else
      raise Errors::BadRequestError.new(I18n.t('controller.api.colleges.create.college_creation_failure'))
    end
  end

  private

  def create_params
    params.permit(
      :college_name
    ).tap do |whitelisted|
      whitelisted.require(:college_name)
    end
  end

  def validate_params_type
    unless create_params[:college_name].is_a?(String)
      raise Errors::BadRequestError.new(I18n.t('controller.api.colleges.create.invalid_data_type'))
    end
  end
end
