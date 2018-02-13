require 'rails_helper'

RSpec.describe IPGroupsService do
  let!(:post_params1) { attributes_for(:post, ip: '1.1.1.1', username: 'Vasya') }
  let!(:post_params2) { attributes_for(:post, ip: '1.1.1.1', username: 'Kolya') }
  let!(:post_params3) { attributes_for(:post, ip: '2.2.2.2', username: 'Vasya') }
  let!(:post_params4) { attributes_for(:post, ip: '3.3.3.3', username: 'Vasya') }
  let!(:post_params5) { attributes_for(:post, ip: '3.3.3.3', username: 'Petya') }
  let!(:expected_result) do
    [
      { ip: '1.1.1.1', users: ['Vasya', 'Kolya'] },
      { ip: '3.3.3.3', users: ['Vasya', 'Petya'] }
    ]
  end

  describe '.execute' do
    before do
      PostHandler.execute(post_params1)
      PostHandler.execute(post_params2)
      PostHandler.execute(post_params3)
      PostHandler.execute(post_params4)
      PostHandler.execute(post_params5)
    end

    it 'returns array of ip groups' do
      result = IPGroupsService.execute

      result.each do |group|
        ip = group[:ip]
        expected_users = expected_result.find { |e| e[:ip] == ip }[:users]

        expect(group[:users]).to contain_exactly(*expected_users)
      end
    end
  end
end
