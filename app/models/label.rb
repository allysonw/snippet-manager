class Label < ActiveRecord::Base
  has_many :snippet_labels
  has_many :snippets, through: :snippet_labels

  validates_presence_of :name
end
