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
  self.inheritance_column = nil
  monetize :balance_cents, presence: true, as: "balance"
  has_many :movements

  validates_presence_of :name, :type
  validates_inclusion_of :type, in: %w(savings credit cash)
end
