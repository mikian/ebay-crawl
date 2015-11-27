class CreateSearchResults < ActiveRecord::Migration
  def change
    create_table :search_results do |t|
      t.string :item_id, unique: true
      t.string :name
      t.decimal :price, precision: 9, scale: 2
      t.string :description
      t.string :link
      t.integer :search_id

      t.timestamps null: false
    end
  end
end
