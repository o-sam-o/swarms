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

ActiveRecord::Schema.define(:version => 20100913105145) do

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres_movies", :id => false, :force => true do |t|
    t.integer "movie_id"
    t.integer "genre_id"
  end

  create_table "movie_images", :force => true do |t|
    t.integer  "movie_id"
    t.string   "file_name"
    t.string   "format"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_stats", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "seeds"
    t.integer  "leaches"
    t.date     "day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", :force => true do |t|
    t.string   "name"
    t.text     "plot"
    t.string   "imdb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.integer  "swarm_score"
    t.string   "director"
    t.string   "classification"
    t.string   "language"
    t.integer  "runtime"
    t.date     "release_date"
    t.integer  "current_rank"
    t.string   "movie_code"
    t.integer  "previous_swarm_score"
  end

  add_index "movies", ["created_at"], :name => "index_movies_on_created_at"
  add_index "movies", ["imdb_id"], :name => "index_movies_on_imdb_id"
  add_index "movies", ["swarm_score"], :name => "index_movies_on_swarm_score"

  create_table "torrent_stats", :force => true do |t|
    t.integer  "seeds"
    t.integer  "leaches"
    t.integer  "torrent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "torrent_stats", ["created_at"], :name => "index_torrent_stats_on_created_at"

  create_table "torrents", :force => true do |t|
    t.string   "name"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "torrents", ["name"], :name => "index_torrents_on_name"

end
