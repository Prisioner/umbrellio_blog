class RateHandler
  include ActiveModel::Validations
  include ActiveModel::Callbacks
  include ActiveModel::Serialization

  validates :post, presence: true
  validates :rate, numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1,
                                   less_than_or_equal_to: 5 }

  define_model_callbacks :create_rate, only: [:after]

  after_create_rate :refresh_post_rating

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
      run_callbacks :create_rate do
        Rate.new.tap do |handler|
          handler.post = @post
          handler.rate = @rate
          handler.save
        end
      end
    end
  end

  def refresh_post_rating
    @rating = @post.refresh_rating
  end
end
