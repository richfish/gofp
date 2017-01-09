class AddDefaultsToAccountFields < ActiveRecord::Migration
  def change
    change_column :accounts, :balance, :integer, default: 0
    change_column :accounts, :total_refunds, :integer, default: 0
    change_column :accounts, :total_earnings, :integer, default: 0
  end
end