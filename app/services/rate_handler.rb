class RateHandler
  include ActiveModel::Validations
  include ActiveModel::Serialization

  validates :post, presence: true
  validates :rate, numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1,
                                   less_than_or_equal_to: 5 }

  attr_reader :rate, :post, :rating

  def self.execute(params, post)
    self.new(params, post).tap do |handler|
      handler.create_rate
    end
  end

  def initialize(params, post)
    @rate = params[:rate]
    @post = post
  end

  def create_rate
    if valid?
      Rate.create(
        post: @post,
        rate: @rate
      )

      refresh_post_rating
    end
  end

  def refresh_post_rating
    @rating = @post.refresh_rating
  end
end
