class Tag < ActiveRecord::Base
	fields do
		name :string
	end
	has_and_belongs_to_many :documents
end
