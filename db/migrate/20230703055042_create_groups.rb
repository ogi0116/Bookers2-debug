class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|

      t.timestamps

      t.string :name
      t.text :introduction
      t.string :image_id
      t.integer :owner_id

    end
  end
end
