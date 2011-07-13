class AddLocaleIdColumn < ActiveRecord::Migration
  def self.up
    [:pages, :messages].each do |table|
      add_column table, :locale_id, :integer
      add_column table, :in_sync, :boolean, :default => true
    end
  end

  def self.down
    [:pages, :messages].each do |table|
      remove_column table, :locale_id
      remove_column table, :in_sync
    end
  end
end
