class Api::V1::PostsController < Api::V1::BaseController
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
