# == Schema Information
#
# Table name: movements
#
#  id              :integer          not null, primary key
#  category        :string
#  sub_category    :string
#  notes           :string
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  period          :date
#  account_id      :string
#  date            :date
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("COP"), not null
#  aasm_state      :string
#

class Income < Movement
  validates_presence_of :date
  validates_presence_of :account
  validates :period, absence: true
  validates_numericality_of :amount_cents, greater_than: 0

  aasm do
    state :reconciled

    event :reconcile do
      transitions :from => :created, :to => :reconciled
    end
  end
end
