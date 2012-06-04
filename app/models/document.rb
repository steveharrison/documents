class Document < ActiveRecord::Base
  fields do
    title :string
    content :text
    uuid :string
    timestamps
  end
  attr_accessible :title, :content, :uuid
  
  # User -> Documents
  belongs_to :user, :inverse_of => :documents
  # Documents <-> Tags
  has_and_belongs_to_many :tags
end
