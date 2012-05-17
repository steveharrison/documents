class Document < ActiveRecord::Base
  fields do
    title :string
    content :text
    timestamps
  end
  attr_accessible :title, :content
  belongs_to :user, :inverse_of => :documents
  has_and_belongs_to_many :tags
end
