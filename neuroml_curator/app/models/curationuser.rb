class Curationuser < ActiveRecord::Base
include Redmine::SafeAttributes

  has_secure_password
  attr_accessible :email, :name, :password_digest, :remember_token

before_create :create_remember_token
public
def new_remember_token
    SecureRandom.urlsafe_base64
  end

  def hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = Curationuser.hash(Curationuser.new_remember_token)
    end
end
