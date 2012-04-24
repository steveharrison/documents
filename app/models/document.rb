class Document < ActiveRecord::Base
  fields do
    title :string
    content :text
    timestamps
  end
  attr_accessible :title, :content
  belongs_to :user, :inverse_of => :documents
end
