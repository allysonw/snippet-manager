class Snippet < ActiveRecord::Base
  belongs_to :user

  has_many :snippet_labels
  has_many :labels, through: :snippet_labels

  validates_presence_of :name, :language, :content, :access_level, :user_id
end
