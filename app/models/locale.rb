class Locale < ActiveRecord::Base
  has_many :pages
  has_many :messages
end
