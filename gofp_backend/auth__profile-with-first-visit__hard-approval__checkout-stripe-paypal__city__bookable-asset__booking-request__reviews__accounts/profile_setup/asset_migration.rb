class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :caption
      t.references :owner, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end