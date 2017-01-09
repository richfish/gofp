class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.text :description
      t.boolean :resolved, default: false
      t.references :issueable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
