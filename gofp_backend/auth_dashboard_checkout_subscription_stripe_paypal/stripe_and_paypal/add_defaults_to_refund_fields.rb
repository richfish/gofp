class AddDefaultsToRefundFields < ActiveRecord::Migration
  def change
    change_column :refunds, :amount_cents, :integer, default: 0
  end
end