class Api::V1::RatesController < Api::V1::BaseController
  before_action :set_post, only: [:create]

  api :POST, '/v1/posts/:id/rates', I18n.t('doc.v1.rates.create')
  param :rate, Hash do
    param :rate, [1, 2, 3, 4, 5], required: true
  end
  param :post_id, :number, required: true
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
