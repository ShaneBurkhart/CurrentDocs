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

ActiveRecord::Schema.define(:version => 20170228225529) do

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contacts", ["contact_id"], :name => "index_contacts_on_contact_id"
  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.string   "target_type"
    t.integer  "target_id"
    t.string   "target_action"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "events", ["target_type", "target_id"], :name => "index_events_on_target_type_and_target_id"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "archived",   :default => false
  end

  create_table "notification_subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.string   "target_type"
    t.string   "target_action"
    t.integer  "target_id"
    t.boolean  "is_active",     :default => true
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "token"
  end

  add_index "notification_subscriptions", ["target_type", "target_id"], :name => "index_notification_subscriptions_on_target_type_and_target_id"
  add_index "notification_subscriptions", ["user_id"], :name => "index_notification_subscriptions_on_user_id"

  create_table "plan_records", :force => true do |t|
    t.string   "plan_name"
    t.string   "filename"
    t.integer  "plan_id",                                       :null => false
    t.integer  "job_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "plan_num"
    t.string   "plan_record_file_name"
    t.string   "plan_record_content_type"
    t.integer  "plan_record_file_size"
    t.datetime "plan_updated_at"
    t.string   "tab",                      :default => "Plans"
    t.string   "csi"
    t.boolean  "archived",                 :default => false
  end

  create_table "plans", :force => true do |t|
    t.string   "plan_name"
    t.string   "filename"
    t.integer  "job_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "plan_num"
    t.string   "plan_file_name"
    t.string   "plan_content_type"
    t.integer  "plan_file_size"
    t.datetime "plan_updated_at"
    t.string   "tab",               :default => "Plans"
    t.string   "status"
    t.string   "csi"
    t.text     "description"
    t.string   "code"
    t.string   "tags"
  end

  create_table "share_links", :force => true do |t|
    t.string   "token"
    t.integer  "job_id"
    t.integer  "user_id"
    t.string   "email_shared_with"
    t.string   "company_name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "shares", :force => true do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "token"
    t.integer  "sharer_id"
    t.boolean  "can_reshare", :default => false
    t.integer  "permissions", :default => 4
  end

  create_table "signup_links", :force => true do |t|
    t.string   "key"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "signup_links", ["user_id"], :name => "index_signup_links_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "",                    :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "type"
    t.string   "authentication_token"
    t.boolean  "expired",                              :default => false
    t.boolean  "cancelled"
    t.string   "company",                              :default => "Company"
    t.datetime "last_seen",                            :default => '2017-07-21 01:35:07'
    t.boolean  "can_share_link",                       :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
