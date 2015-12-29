# == Schema Information
#
# Table name: accounts
#
#  id               :integer          not null, primary key
#  name             :string
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  balance_cents    :integer          default(0), not null
#  balance_currency :string           default("COP"), not null
#

class Account < ActiveRecord::Base
  self.inheritance_column = nil
  monetize :balance_cents, presence: true, as: "balance"
  has_many :movements

  validates_presence_of :name, :type, :balance_cents
  validates_inclusion_of :type, in: %w(savings credit cash)
end
