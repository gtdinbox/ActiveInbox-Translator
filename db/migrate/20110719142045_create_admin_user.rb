class CreateAdminUser < ActiveRecord::Migration
  def self.up
    admin = User.new(
      :name => 'admin',
      :email => 'admin@example.com',
      :is_admin => true,
      :password => 'password'
    )

    admin.is_admin=true
    if admin.save and admin.is_admin
      puts "admin user created"
    else
      puts "something whent wrong"
      pp admin.errors
    end
  end

  def self.down
  end
end
