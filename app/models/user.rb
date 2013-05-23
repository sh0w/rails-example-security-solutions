class User < ActiveRecord::Base
  has_many :articles

  attr_accessible :name, :email, :homepage, :is_admin, :password_hash, :password_salt, :password
  attr_accessor :password
  before_save :encrypt_password

  #validates_confirmation_of :password
  validates_presence_of :password, :on => :create

  validates :name, :email, :password, :presence => true
  validates :email, :format =>  { :with => /@.+\./, :message => "E-Mail should contain @ and at least one dot" }

  def to_s
    name
  end

  def admin?
    is_admin
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
end
