class User < ActiveRecord::Base
  has_many :snippets
  has_secure_password
end
