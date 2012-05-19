class ChangeForeignKeysForCharacterAndCharacterImage < ActiveRecord::Migration
  def up
  	remove_column :characters, :character_image_id
  	add_column :character_images, :character_id, :integer
  end

  def down
  	add_column :characters, :character_image_id, :integer
  	remove_column :character_images, :character_id
  end
end
