class CreateSiteSubscriptions < ActiveRecord::Migration
  def change
    create_table :site_subscriptions do |t|
      t.string :email

      t.timestamps null: false
    end
  end
end
