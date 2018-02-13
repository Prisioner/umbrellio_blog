require 'rails_helper'

RSpec.describe Api::V1::RatesController, type: :controller do
  let(:post_params) { attributes_for(:post) }
  let!(:some_post) { Post.find(PostHandler.execute(post_params).id) }
  let(:rate_params) { attributes_for(:rate, rate: 5) }
  let(:invalid_rate_params) { attributes_for(:rate, rate: -1) }

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates new rate in database' do
        expect { post :create, params: { rate: rate_params , post_id: some_post }, format: :json }.to change(some_post.rates, :count).by(1)
      end

      it 'returns code 200' do
        post :create, params: { rate: rate_params , post_id: some_post }, format: :json

        code = JSON.parse(response.body)['code']

        expect(code).to eq 200
        expect(response.code).to eq '200'
      end

      it 'updates post rating' do
        expect do
          post :create, params: { rate: rate_params , post_id: some_post }, format: :json
          some_post.reload
        end.to change(some_post, :rating).from(0).to(5)
      end

      it 'returns new post rating' do
        post :create, params: { rate: rate_params , post_id: some_post }, format: :json

        rating = JSON.parse(response.body)['post']['rating']

        expect(rating).to eq '5.0'
      end
    end

    context 'with invalid params' do
      context 'rate params is invalid' do
        it 'returns code 422' do
          post :create, params: { rate: invalid_rate_params , post_id: some_post }, format: :json

          code = JSON.parse(response.body)['code']

          expect(code).to eq 422
          expect(response.code).to eq '422'
        end

        it 'returns validation errors' do
          post :create, params: { rate: invalid_rate_params , post_id: some_post }, format: :json

          json = JSON.parse(response.body)

          expect(json['errors']).to be
        end
      end

      context 'post id is invalid' do
        it 'returns code 404' do
          post :create, params: { rate: rate_params , post_id: -1 }, format: :json

          code = JSON.parse(response.body)['code']

          expect(code).to eq 404
          expect(response.code).to eq '404'
        end

        it 'returns errors' do
          post :create, params: { rate: rate_params , post_id: -1 }, format: :json

          json = JSON.parse(response.body)

          expect(json['errors']).to be
        end
      end
    end
  end
end
