class AddGenderToCharacters < ActiveRecord::Migration
  def change
  	# default to 'female', bugs will be more hilarious
  	add_column :characters, :gender, :string, :default => "female"
  end
end
