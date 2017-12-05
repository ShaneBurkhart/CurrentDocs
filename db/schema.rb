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

ActiveRecord::Schema.define(:version => 20171124192325) do

  create_table "documents", :force => true do |t|
    t.string   "original_filename",         :null => false
    t.string   "s3_path",                   :null => false
    t.integer  "user_id",                   :null => false
    t.integer  "document_association_id"
    t.string   "document_association_type"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "documents", ["s3_path"], :name => "index_documents_on_s3_path", :unique => true
  add_index "documents", ["user_id"], :name => "index_documents_on_user_id"

  create_table "job_permissions", :force => true do |t|
    t.integer  "job_id",                            :null => false
    t.integer  "permissions_id",                    :null => false
    t.boolean  "can_update",     :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "job_permissions", ["job_id"], :name => "index_job_permissions_on_job_id"
  add_index "job_permissions", ["permissions_id"], :name => "index_job_permissions_on_permissions_id"

  create_table "jobs", :force => true do |t|
    t.string   "name",                           :null => false
    t.boolean  "is_archived", :default => false
    t.integer  "user_id",                        :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "jobs", ["is_archived"], :name => "index_jobs_on_is_archived"
  add_index "jobs", ["user_id"], :name => "index_jobs_on_user_id"

  create_table "permissions", :force => true do |t|
    t.integer  "authenticatable_id"
    t.string   "authenticatable_type"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "plan_documents", :force => true do |t|
    t.integer  "plan_id",                       :null => false
    t.boolean  "is_current", :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "plan_documents", ["is_current"], :name => "index_plan_documents_on_is_current"
  add_index "plan_documents", ["plan_id"], :name => "index_plan_documents_on_plan_id"

  create_table "plan_tab_permissions", :force => true do |t|
    t.string   "tab",                                  :null => false
    t.integer  "job_permission_id",                    :null => false
    t.boolean  "can_create",        :default => false
    t.boolean  "can_update",        :default => false
    t.boolean  "can_destroy",       :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "plan_tab_permissions", ["job_permission_id"], :name => "index_plan_tab_permissions_on_job_permission_id"

  create_table "plans", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "tab",        :null => false
    t.integer  "job_id",     :null => false
    t.integer  "order_num",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "plans", ["job_id"], :name => "index_plans_on_job_id"
  add_index "plans", ["order_num"], :name => "index_plans_on_order_num"
  add_index "plans", ["tab"], :name => "index_plans_on_tab"

  create_table "share_links", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "token",      :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "share_links", ["token"], :name => "index_share_links_on_token", :unique => true
  add_index "share_links", ["user_id"], :name => "index_share_links_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "first_name",                             :null => false
    t.string   "last_name",                              :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
