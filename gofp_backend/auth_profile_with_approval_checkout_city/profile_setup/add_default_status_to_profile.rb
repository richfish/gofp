class AddDefaultStatusToProfile < ActiveRecord::Migration
  def change
    change_column :profiles, :status, :string, :default => Profile::STATUS_NEW
  end
end
