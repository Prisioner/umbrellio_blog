require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  describe 'POST #create' do
    context 'with valid params' do
      let!(:user) { create(:user) }
      let(:post_params) { attributes_for(:post, username: user.username) }

      it 'creates new post in database' do
        expect { post :create, params: { post: post_params }, format: :json }.to change(Post, :count).by(1)
      end

      it 'returns code 200' do
        post :create, params: { post: post_params }, format: :json

        code = JSON.parse(response.body)['code']

        expect(code).to eq 200
        expect(response.code).to eq '200'
      end

      it 'returns post parameters' do
        post :create, params: { post: { title: 'Title', body: 'Body', ip: '1.1.1.1', username: 'UserName' } }, format: :json

        post = JSON.parse(response.body)['post']

        expect(post['title']).to eq 'Title'
        expect(post['body']).to eq 'Body'
        expect(post['ip']).to eq '1.1.1.1'
        expect(post['username']).to eq 'UserName'
        expect(post['id']).to be
      end

      context 'posted by existing user' do
        it 'does not create new users in database' do
          expect { post :create, params: { post: post_params }, format: :json }.to_not change(User, :count)
        end
      end

      context 'posted by new user' do
        let(:post_params) { attributes_for(:post, username: 'absolutely_new_username') }

        it 'creates new user in database' do
          expect { post :create, params: { post: post_params }, format: :json }.to change(User, :count).by(1)
        end
      end
    end

    context 'with invalid params' do
      let(:post_params) { attributes_for(:post, title: nil) }

      it 'does not create new posts in database' do
        expect { post :create, params: { post: post_params }, format: :json }.to_not change(Post, :count)
      end

      it 'does not create new users in database' do
        expect { post :create, params: { post: post_params }, format: :json }.to_not change(User, :count)
      end

      it 'returns code 422' do
        post :create, params: { post: post_params }, format: :json

        code = JSON.parse(response.body)['code']

        expect(code).to eq 422
        expect(response.code).to eq '422'
      end

      it 'returns validation errors' do
        post :create, params: { post: post_params }, format: :json

        json = JSON.parse(response.body)

        expect(json['errors']).to be
      end
    end
  end

  describe 'GET #top' do
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

    context 'with valid params' do
      it 'returns code 200' do
        get :top, params: { count: 2 }, format: :json

        code = JSON.parse(response.body)['code']

        expect(code).to eq 200
        expect(response.code).to eq '200'
      end

      it 'returns correct post array' do
        get :top, params: { count: 2 }, format: :json

        id_list = JSON.parse(response.body)['posts'].map { |post| post['id'] }

        expect(id_list).to contain_exactly(post1.id, post2.id)
      end
    end

    context 'with invalid params' do
      it 'returns code 200' do
        get :top, params: { count: nil }, format: :json

        code = JSON.parse(response.body)['code']

        expect(code).to eq 200
        expect(response.code).to eq '200'
      end

      it 'returns empty post array'do
        get :top, params: { count: nil }, format: :json

        json = JSON.parse(response.body)

        expect(json['posts']).to be_empty
      end
    end
  end
end
