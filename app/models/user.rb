class User < ActiveRecord::Base
  has_many :snippets
  has_many :labels, through: :snippets
  has_secure_password
  validates_presence_of :username, :email, :password_digest

  def slug
    self.username.downcase.gsub(/ /, "-")
  end

  def self.find_by_slug(slug)
    self.all.find do |object|
      object.slug == slug
    end
  end

end
