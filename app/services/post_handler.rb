class PostHandler
  include ActiveModel::Validations
  include ActiveModel::Serialization

  validates :title, presence: true
  validates :body, presence: true
  validates :ip, presence: true, ip: true
  validates :username, presence: true

  define_model_callbacks :initialize, only: [:after]

  attr_reader :username, :title, :body, :ip

  def self.execute(params)
    self.new(params).tap do |handler|
      handler.create_post
    end
  end

  def initialize(params)
    @username = params[:username]
    @title = params[:title]
    @body = params[:body]
    @ip = params[:ip]
  end

  def create_post
    if valid?
      Post.new.tap do |handler|
        handler.user = User.find_or_create_by(username: @username)
        handler.title = @title
        handler.body = @body
        handler.ip = @ip
        handler.save
      end
    end
  end
end
