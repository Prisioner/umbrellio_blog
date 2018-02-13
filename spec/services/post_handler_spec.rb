require 'rails_helper'

RSpec.describe PostHandler do
  describe 'validations' do
    let!(:post_params) { attributes_for(:post) }
    let!(:valid_handler) { PostHandler.new(post_params) }

    it 'everything ok' do
      expect(valid_handler).to be_valid
    end

    it 'should validate presence of title' do
      invalid_handler = PostHandler.new(attributes_for(:post, title: nil))

      expect(invalid_handler).to_not be_valid
      expect(invalid_handler.errors[:title]).to be
    end

    it 'should validate presence of body' do
      invalid_handler = PostHandler.new(attributes_for(:post, body: nil))

      expect(invalid_handler).to_not be_valid
      expect(invalid_handler.errors[:body]).to be
    end

    it 'should validate presence of username' do
      invalid_handler = PostHandler.new(attributes_for(:post, username: nil))

      expect(invalid_handler).to_not be_valid
      expect(invalid_handler.errors[:username]).to be
    end

    it 'should validate presence of ip' do
      invalid_handler = PostHandler.new(attributes_for(:post, ip: nil))

      expect(invalid_handler).to_not be_valid
      expect(invalid_handler.errors[:ip]).to be
    end

    it 'should validate ip' do
      invalid_handler = PostHandler.new(attributes_for(:post, ip: 'not.a.valid.ip'))

      expect(invalid_handler).to_not be_valid
      expect(invalid_handler.errors[:ip]).to be
    end
  end

  describe '#create_post' do
    context 'with valid params' do
      let!(:user) { create(:user) }
      let(:post_params) { attributes_for(:post, username: user.username) }

      it 'create post in database' do
        expect { PostHandler.new(post_params).create_post }.to change(Post, :count).by(1)
      end

      context 'posted with existed username' do
        it 'does not create user in database' do
          expect { PostHandler.new(post_params).create_post }.to_not change(User, :count)
        end
      end

      context 'posted with new username' do
        let(:new_user_post_params) { attributes_for(:post) }

        it 'creates user in database' do
          expect { PostHandler.new(new_user_post_params).create_post }.to change(User, :count).by(1)
        end
      end
    end

    context 'with invalid params' do
      let(:post_params) { attributes_for(:post, title: nil, username: 'absolutely_new_username') }

      it 'does not create post in database' do
        expect { PostHandler.new(post_params).create_post }.to_not change(Post, :count)
      end

      it 'does not create user in database' do
        expect { PostHandler.new(post_params).create_post }.to_not change(User, :count)
      end
    end
  end
end
