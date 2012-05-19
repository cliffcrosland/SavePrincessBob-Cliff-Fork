class Character < ActiveRecord::Base
	belongs_to :game
	has_one :character_image
end
