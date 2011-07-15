# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110715090219) do

  create_table "locales", :force => true do |t|
    t.string   "name"
    t.string   "lang_code"
    t.boolean  "is_master"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.boolean  "deleted",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.boolean  "in_sync",    :default => true
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.boolean  "deleted",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.boolean  "in_sync",    :default => true
  end

  create_table "users", :force => true do |t|
    t.string   "email",              :null => false
    t.string   "name"
    t.string   "encrypted_password", :null => false
    t.string   "salt",               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
