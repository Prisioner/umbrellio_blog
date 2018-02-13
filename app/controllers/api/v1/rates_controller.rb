class Api::V1::RatesController < Api::V1::BaseController
  before_action :set_post, only: [:create]

  def create
    @handler = RateHandler.execute(rate_params, @post)

    respond_to do |format|
      if @handler.valid?
        format.json { render json: { code: 200, post: RateHandlerSerializer.new(@handler) }, status: 200 }
      else
        format.json { render json: { code: 422, errors: @handler.errors.full_messages }, status: 422 }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def rate_params
    params.require(:rate).permit(:rate)
  end
end
