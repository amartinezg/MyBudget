# == Schema Information
#
# Table name: movements
#
#  id           :integer          not null, primary key
#  category     :string
#  sub_category :string
#  notes        :string
#  amount_cents :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  period       :date
#  account_id   :string           not null
#  date         :date
#

require 'test_helper'

class MovementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
