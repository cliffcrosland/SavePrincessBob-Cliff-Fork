class CreateCharacterImages < ActiveRecord::Migration
  def change
    create_table :character_images do |t|
      t.string :image_url
      t.float :x_displacement
      t.float :y_displacement
      t.float :rotation
      t.float :zoom

      t.timestamps
    end
  end
end
