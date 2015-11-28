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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151127112842) do

  create_table "comments", force: :cascade do |t|
    t.string   "recsts",     limit: 1,     default: "0"
    t.string   "typ",        limit: 255
    t.integer  "idcd",       limit: 4
    t.integer  "mem_id",     limit: 4
    t.text     "con",        limit: 65535
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "docs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "con",        limit: 4294967295
    t.text     "markdown",   limit: 4294967295
    t.string   "cover",      limit: 55
    t.integer  "mem_id",     limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "docsubs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "mem_id",     limit: 4
    t.text     "con",        limit: 65535
    t.string   "status",     limit: 10,    default: "UNREAD"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "mauths", force: :cascade do |t|
    t.string   "recsts",     limit: 1,   default: "0"
    t.integer  "mem_id",     limit: 4
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "mem_infos", force: :cascade do |t|
    t.integer  "mem_id",     limit: 4
    t.string   "gender",     limit: 255
    t.string   "location",   limit: 255
    t.string   "html_url",   limit: 255
    t.string   "blog",       limit: 255
    t.integer  "followers",  limit: 4
    t.integer  "following",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "github",     limit: 255
    t.string   "twitter",    limit: 255
    t.string   "weibo_nc",   limit: 255
    t.string   "weibo_url",  limit: 255
  end

  create_table "mem_repos", force: :cascade do |t|
    t.integer  "mem_id",           limit: 4
    t.string   "name",             limit: 255
    t.string   "description",      limit: 255
    t.string   "html_url",         limit: 255
    t.integer  "stargazers_count", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "mems", force: :cascade do |t|
    t.string   "nc",         limit: 255
    t.string   "email",      limit: 255
    t.string   "avatar",     limit: 100
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "pwd",        limit: 255
  end

  add_index "mems", ["nc", "email"], name: "search", using: :btree

  create_table "menutyps", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.string   "sdesc",      limit: 255
    t.string   "fdesc",      limit: 255
    t.string   "parent",     limit: 255
    t.string   "typcd",      limit: 255
    t.text     "home",       limit: 65535
    t.integer  "num",        limit: 4,     default: 0
    t.string   "icon",       limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "home_index", limit: 4,     default: 0
  end

  create_table "notifies", force: :cascade do |t|
    t.integer  "mem_id",     limit: 4
    t.string   "typcd",      limit: 255
    t.integer  "amount",     limit: 4,   default: 0
    t.string   "desc",       limit: 255
    t.string   "fdesc",      limit: 255
    t.string   "state",      limit: 255, default: "UNREAD"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "opers", force: :cascade do |t|
    t.string   "typ",        limit: 255
    t.integer  "idcd",       limit: 4
    t.integer  "mem_id",     limit: 4
    t.string   "opertyp",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "readmes", force: :cascade do |t|
    t.integer  "mem_id",     limit: 4
    t.integer  "repo_id",    limit: 4
    t.text     "about",      limit: 4294967295
    t.text     "old",        limit: 4294967295
    t.string   "sdesc",      limit: 200,        default: "初始化文档"
    t.string   "status",     limit: 45,         default: "UNREAD"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "repo_notifies", force: :cascade do |t|
    t.integer  "repo_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "repo_resources", force: :cascade do |t|
    t.string   "recsts",     limit: 2,   default: "1"
    t.string   "title",      limit: 255
    t.string   "url",        limit: 255
    t.string   "repo_alia",  limit: 255
    t.integer  "mem_id",     limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "repo_id",    limit: 4
  end

  create_table "repo_trends", force: :cascade do |t|
    t.integer  "repo_id",    limit: 4
    t.integer  "overall",    limit: 4
    t.date     "date"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "trend",      limit: 4, default: 0
  end

  create_table "repos", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "full_name",         limit: 255
    t.string   "alia",              limit: 255
    t.string   "html_url",          limit: 255
    t.string   "description",       limit: 1000
    t.string   "description_cn",    limit: 1000
    t.string   "homepage",          limit: 255
    t.integer  "stargazers_count",  limit: 4
    t.integer  "forks_count",       limit: 4
    t.integer  "subscribers_count", limit: 4
    t.datetime "pushed_at"
    t.text     "about",             limit: 4294967295
    t.text     "about_zh",          limit: 4294967295
    t.string   "typcd",             limit: 255
    t.string   "rootyp",            limit: 255
    t.string   "owner",             limit: 100
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "outdated",          limit: 1,          default: "0"
    t.string   "tag",               limit: 255
    t.string   "cover",             limit: 255
    t.integer  "recommend",         limit: 4,          default: 0
    t.integer  "trend",             limit: 4,          default: 0
    t.datetime "github_created_at"
  end

  add_index "repos", ["rootyp", "typcd", "html_url"], name: "search", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "typ",        limit: 255
    t.string   "sdesc",      limit: 255
    t.text     "fdesc",      limit: 65535
    t.integer  "var",        limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "submits", force: :cascade do |t|
    t.string   "html_url",   limit: 255
    t.string   "rootyp",     limit: 255
    t.string   "typcd",      limit: 255
    t.string   "status",     limit: 45,  default: "UNREAD"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "con",        limit: 65535
    t.string   "typcd",      limit: 255
    t.integer  "mem_id",     limit: 4
    t.string   "author",     limit: 255
    t.string   "origin",     limit: 255
    t.string   "state",      limit: 1,     default: "1"
    t.integer  "visit",      limit: 4,     default: 0
    t.integer  "favor",      limit: 4,     default: 0
    t.integer  "comment",    limit: 4,     default: 0
    t.string   "tag",        limit: 255
    t.string   "var1",       limit: 255
    t.string   "var2",       limit: 255
    t.integer  "var3",       limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

end
