require 'bcrypt'

def password_encrypt(password)
  my_password = BCrypt::Password.create(password)
end


