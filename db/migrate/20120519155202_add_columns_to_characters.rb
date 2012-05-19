class AddColumnsToCharacters < ActiveRecord::Migration
  def change
  	add_column :characters, :character_facebook_id, :bigint
  	add_column :characters, :game_id, :integer
  	add_column :characters, :character_image_id, :integer
  	add_column :characters, :role, :string
  end
end
