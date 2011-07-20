class User < ActiveRecord::Base

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }


  validates :email, :presence => true,
                    :uniqueness => true,
                    :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

  before_save :encrypt_password



  def self.authenticate(email, password)
    user = User.find_by_email(email)
    user if user.has_password?(password)
  end

  def has_password?(submitted_password)
    encrypted_password === encrypt(submitted_password)
  end
  private
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
