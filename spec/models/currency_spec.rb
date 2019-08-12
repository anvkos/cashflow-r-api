require 'rails_helper'

RSpec.describe Currency, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of :symbol }
  end
end
