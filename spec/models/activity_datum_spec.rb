require 'rails_helper'

describe ActivityDatum, type: :model do

  subject { Fabricate.build(:activity_datum) }

  describe 'validations' do
    it { should validate_inclusion_of(:activity).in_array(%w[driving cultivating repairing slacking_off awol]) }
  end

end
