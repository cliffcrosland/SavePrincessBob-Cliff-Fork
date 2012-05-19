class AddCreatorFacebookIdColumnToGames < ActiveRecord::Migration
  def change
  	# Use a big integer in the database
  	add_column :games, :creator_facebook_id, :bigint
  end
end
