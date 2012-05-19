class MakeFacebookIdsAllBigint < ActiveRecord::Migration
  def up
  	change_column :characters, :character_facebook_id, :integer, :limit => 8
  	change_column :games, :creator_facebook_id, :integer, :limit => 8
  end

  def down
  	change_column :characters, :character_facebook_id, :integer
  	change_column :games, :creator_facebook_id, :integer
  end
end
