class Document < ActiveRecord::Base
  # attr_accessible :title, :body
  fields do
    title :string
    body :text
    timestamps
  end
end
