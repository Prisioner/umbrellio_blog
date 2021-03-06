class Api::V1::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |e|
    respond_to do |format|
      format.json { render json: { code: 404, errors: e.message }, status: 404 }
    end
  end

  rescue_from Apipie::ParamMissing, Apipie::ParamInvalid do |e|
    respond_to do |format|
      format.json { render json: { code: 422, errors: e.message }, status: 422 }
    end
  end

end
