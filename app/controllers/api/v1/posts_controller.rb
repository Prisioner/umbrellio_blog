class Api::V1::PostsController < Api::V1::BaseController
  api :POST, '/v1/posts', I18n.t('doc.v1.posts.create')
  param :post, Hash do
    param :title, String, required: true
    param :body, String, required: true
    param :ip, String, required: true
    param :username, String, required: true
  end
  def create
    @post = PostHandler.execute(post_params)

    respond_to do |format|
      if @post.valid?
        format.json { render json: { code: 200, post: PostHandlerSerializer.new(@post) }, status: 200 }
      else
        format.json { render json: { code: 422, errors: @post.errors.full_messages }, status: 422 }
      end
    end
  end

  api :GET, '/v1/posts/top', I18n.t('doc.v1.posts.top')
  param :count, :number, required: true
  def top
    @posts = Post.top(params[:count].to_i)

    respond_to do |format|
      format.json { render json: { code: 200, posts: @posts.map { |p| PostSerializer.new(p) } }, status: 200 }
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :ip, :username)
  end
end
