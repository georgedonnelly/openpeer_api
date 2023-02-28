class CreateDisputeFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :dispute_files do |t|
      t.references :dispute, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :filename

      t.timestamps
    end
  end
end
