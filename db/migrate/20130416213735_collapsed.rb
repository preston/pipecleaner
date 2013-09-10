class Collapsed < ActiveRecord::Migration

  def change

  create_table "delayed_jobs", :force => true do |t|
    t.integer   "priority",   :default => 0
    t.integer   "attempts",   :default => 0
    t.text      "handler"
    t.text      "last_error"
    t.timestamp "run_at"
    t.timestamp "locked_at"
    t.timestamp "failed_at"
    t.string    "locked_by"
    t.string    "queue"
    t.timestamp "created_at",                :null => false
    t.timestamp "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "favorites", :force => true do |t|
    t.integer   "user_id",    :null => false
    t.integer   "member_id",  :null => false
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "items", :force => true do |t|
    t.string    "name"
    t.text      "notes"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
    t.integer   "created_by"
  end

  add_index "items", ["name"], :name => "index_items_on_name", :unique => true

  create_table "members", :force => true do |t|
    t.integer   "pipeline_id"
    t.integer   "item_id"
    t.timestamp "created_at",                     :null => false
    t.timestamp "updated_at",                     :null => false
    t.boolean   "archived",    :default => false
  end

  create_table "pipelines", :force => true do |t|
    t.string    "name"
    t.text      "description"
    t.string    "code"
    t.timestamp "created_at",  :null => false
    t.timestamp "updated_at",  :null => false
    t.integer   "created_by"
  end

  add_index "pipelines", ["code"], :name => "index_pipelines_on_code", :unique => true
  add_index "pipelines", ["name"], :name => "index_pipelines_on_name", :unique => true

  create_table "rails_admin_histories", :force => true do |t|
    t.text      "message"
    t.string    "username"
    t.integer   "item"
    t.string    "table"
    t.integer   "month"
    t.integer   "year"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "services", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "verb"
    t.boolean  "include_basic"
    t.boolean  "include_data"
    t.boolean  "include_extended"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string    "session_id", :null => false
    t.text      "data"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "stages", :force => true do |t|
    t.integer   "pipeline_id"
    t.string    "name"
    t.text      "description"
    t.timestamp "created_at",  :null => false
    t.timestamp "updated_at",  :null => false
    t.integer   "number"
  end

  add_index "stages", ["name"], :name => "index_stages_on_name"

  create_table "statuses", :force => true do |t|
    t.integer   "member_id"
    t.integer   "stage_id"
    t.timestamp "created_at",                        :null => false
    t.timestamp "updated_at",                        :null => false
    t.string    "code",       :default => "default"
    t.integer   "created_by"
  end

  create_table "taggings", :force => true do |t|
    t.integer   "tag_id"
    t.integer   "taggable_id"
    t.string    "taggable_type"
    t.integer   "tagger_id"
    t.string    "tagger_type"
    t.string    "context",       :limit => 128
    t.timestamp "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "triggers", :force => true do |t|
    t.integer   "stage_id"
    t.string    "url"
    t.string    "verb"
    t.string    "event"
    t.string    "condition"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string    "email",                  :default => "",     :null => false
    t.string    "encrypted_password",     :default => "",     :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.string    "confirmation_token"
    t.timestamp "confirmed_at"
    t.timestamp "confirmation_sent_at"
    t.string    "unconfirmed_email"
    t.string    "authentication_token"
    t.timestamp "created_at",                                 :null => false
    t.timestamp "updated_at",                                 :null => false
    t.boolean   "approved",               :default => false
    t.string    "role",                   :default => "user"
  end

  add_index "users", ["approved"], :name => "index_users_on_approved"
  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["role"], :name => "index_users_on_role"

  end
 
end
