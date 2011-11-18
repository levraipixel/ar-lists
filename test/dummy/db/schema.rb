ActiveRecord::Schema.define(:version => 20111103152541) do

  create_table "linkedin_accounts", :force => true do |t|
    t.integer  "user_id"
    t.text     "first_connections"
    t.string   "token"
    t.string   "secret"
    t.string   "cached_first_name"
    t.string   "cached_last_name"
    t.string   "cached_picture_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_id",             :limit => 16
  end

