require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:currency) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :amount }
    it { should validate_numericality_of(:amount) }
  end


end
