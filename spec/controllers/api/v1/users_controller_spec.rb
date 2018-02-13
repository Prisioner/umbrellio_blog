require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:post_params1) { attributes_for(:post, ip: '1.1.1.1', username: 'Vasya') }
  let!(:post_params2) { attributes_for(:post, ip: '1.1.1.1', username: 'Kolya') }
  let!(:post_params3) { attributes_for(:post, ip: '2.2.2.2', username: 'Vasya') }
  let!(:post_params4) { attributes_for(:post, ip: '3.3.3.3', username: 'Vasya') }
  let!(:post_params5) { attributes_for(:post, ip: '3.3.3.3', username: 'Petya') }
  let!(:expected_result) do
    [
        { ip: '1.1.1.1', users: ['Kolya', 'Vasya'] },
        { ip: '3.3.3.3', users: ['Petya', 'Vasya'] }
    ]
  end

  before do
    PostHandler.execute(post_params1)
    PostHandler.execute(post_params2)
    PostHandler.execute(post_params3)
    PostHandler.execute(post_params4)
    PostHandler.execute(post_params5)
  end

  describe 'GET #ip_groups' do
    it 'returns correct ip groups' do
      get :ip_groups, format: :json

      data = JSON.parse(response.body)['data'].map(&:symbolize_keys)

      data.each do |group|
        ip = group[:ip]
        expected_users = expected_result.find { |e| e[:ip] == ip }[:users]

        expect(group[:users]).to contain_exactly(*expected_users)
      end
    end

    it 'returns code 200' do
      get :ip_groups, format: :json

      code = JSON.parse(response.body)['code']

      expect(code).to eq 200
      expect(response.code).to eq '200'
    end
  end
end
