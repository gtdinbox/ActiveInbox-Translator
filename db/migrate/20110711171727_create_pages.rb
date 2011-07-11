class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :name
      t.text :content
      t.boolean :deleted, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
