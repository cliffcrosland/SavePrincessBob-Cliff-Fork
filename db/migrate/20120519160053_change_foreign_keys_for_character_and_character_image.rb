class ChangeForeignKeysForCharacterAndCharacterImage < ActiveRecord::Migration
  def change
  	remove_column :characters, :character_image_id
  	add_column :character_images, :character_id, :integer
  end
end
