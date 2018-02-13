require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations check' do
    it { should belong_to :user }
    it { should have_many :rates }

    it { should delegate_method(:username).to(:user) }
  end

  describe '.top' do
    let!(:post_params) { attributes_for(:post) }
    let!(:post2) { Post.find(PostHandler.execute(post_params).id) }
    let!(:post3) { Post.find(PostHandler.execute(post_params).id) }
    let!(:post1) { Post.find(PostHandler.execute(post_params).id) }
    let!(:post4) { Post.find(PostHandler.execute(post_params).id) }

    before do
      RateHandler.execute({ rate: 5 }, post1)
      RateHandler.execute({ rate: 4 }, post2)
      RateHandler.execute({ rate: 3 }, post3)
      RateHandler.execute({ rate: 2 }, post4)
    end

    it 'should have the top scope' do
      expect(Post).to respond_to(:top)
    end

    it 'returns correct top posts' do
      expect(Post.top(2)).to eq [post1, post2]
    end
  end
end
