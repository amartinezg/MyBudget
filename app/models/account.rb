# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  name          :string
#  type          :string
#  balance_cents :integer
#  currency      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Account < ActiveRecord::Base
  monetize :balance_cents, presence: true
  has_many :movements
end
