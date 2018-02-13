require 'rails_helper'

RSpec.describe Rate, type: :model do
  describe 'associations check' do
    it { should belong_to :post }
  end
end
