require 'rails_helper'

RSpec.describe RateHandler do
  let!(:post) do
    Post.find(
      PostHandler.execute(attributes_for(:post)).id
    )
  end

  describe 'validations check' do
    let(:rate_params) { attributes_for(:rate) }
    let(:valid_handler) { RateHandler.new(rate_params, post) }

    it 'everything ok' do
      expect(valid_handler).to be_valid
    end

    it 'should validate presence of post' do
      invalid_handler = RateHandler.new(rate_params, nil)

      expect(invalid_handler).to_not be_valid
      expect(invalid_handler.errors[:post]).to be
    end

    it 'should validate presence of rate' do
      invalid_handler = RateHandler.new({ }, post)

      expect(invalid_handler).to_not be_valid
      expect(invalid_handler.errors[:rate]).to be
    end

    it 'should validate value of rate - must be 5 or less' do
      invalid_handler = RateHandler.new({rate: 6}, post)

      expect(invalid_handler).to_not be_valid
      expect(invalid_handler.errors[:rate]).to be
    end

    it 'should validate value of rate - must be 1 or more' do
      invalid_handler = RateHandler.new({rate: 0}, post)

      expect(invalid_handler).to_not be_valid
      expect(invalid_handler.errors[:rate]).to be
    end
  end

  describe '#create_rate' do
    context 'with valid params' do
      it 'create rate in database' do
        expect { RateHandler.new({rate: 5}, post).create_rate }.to change(Rate, :count).by(1)
      end

      it 'update post rating' do
        expect { RateHandler.new({rate: 5}, post).create_rate }.to change(post, :rating).from(0).to(5)
      end
    end

    context 'with invalid params' do
      it 'does not create rate in database' do
        expect { RateHandler.new({rate: 6}, post).create_rate }.to_not change(Rate, :count)
      end

      it 'does not change post rating' do
        expect { RateHandler.new({rate: 6}, post).create_rate }.to_not change(post, :rating)
      end
    end
  end
end
