# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20111229045144) do

  create_table "resource_infos", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.string   "author"
    t.string   "author_avatar"
    t.integer  "user_id"
    t.string   "state"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "thread_parts", :force => true do |t|
    t.text     "content"
    t.text     "raw_content"
    t.integer  "resource_info_id"
    t.string   "uid"
    t.datetime "post_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table :photo_previews do |t|
    t.string :photo
    t.integer :resource_info_id

    t.timestamps
  end

  create_table :delayed_jobs, :force => true do |table|
    table.integer  :priority, :default => 0      # Allows some jobs to jump to the front of the queue
    table.integer  :attempts, :default => 0      # Provides for retries, but still fail eventually.
    table.text     :handler                      # YAML-encoded string of the object that will do work
    table.text     :last_error                   # reason for last failure (See Note below)
    table.datetime :run_at                       # When to run. Could be Time.zone.now for immediately, or sometime in the future.
    table.datetime :locked_at                    # Set when a client is working on this object
    table.datetime :failed_at                    # Set when all retries have failed (actually, by default, the record is deleted instead)
    table.string   :locked_by                    # Who is working on this object (if locked)
    table.string   :queue                        # The name of the queue this job is in
    table.timestamps
  end

  add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'

 create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "invite_code"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index :users, :email,                :unique => true
  add_index :users, :reset_password_token, :unique => true

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table :favorates do |t|
    t.integer :user_id
    t.integer :resource_info_id

    t.timestamps
  end

  create_table :invite_codes do |t|
    t.string :code
    t.boolean :used,:default=>false

    t.timestamps
  end

  create_table :user_rates do |t|
    t.integer :user_id
    t.integer :resource_info_id
    t.integer :rate

    t.timestamps
  end

end
