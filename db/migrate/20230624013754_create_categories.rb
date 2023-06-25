class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :emoji
      t.integer :limit
      t.references :user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

