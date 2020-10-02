class API::VideosController < ApplicationController
  def index
    query = Zype::Videos::List.execute(params[:page])
    if query.success?
      render json: { response: query.response, pagination: query.pagination }
    else
      head :service_unavailable
    end
  end

  def show
    query = Zype::Videos::Get.execute(params[:id], zype_session)
    if query.success?
      render json: query.video.to_h
    elsif query.unauthorized?
      head :unauthorized
    elsif query.forbidden?
      head :forbidden
    else
      head :service_unavailable
    end
  end
end
