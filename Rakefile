require "sequel"
require "dotenv"
require "csv"

Dotenv.load

namespace :db do
  task :setup do
    DB = Sequel.connect(ENV["DATABASE"])

    DB.create_table(:comments) do
      primary_key :id
      String :reddit_id,  :unique => true
      String :kind
      String :name
      String :subreddit
      String :body,       :text => true
      String :link_id
      String :link_title, :text => true
      String :link_url,   :text => true
    end

    DB.create_table(:links) do
      primary_key :id
      String  :reddit_id, :unique => true
      String  :kind
      String  :name
      String  :subreddit
      String  :title,     :text => true
      Boolean :is_self
      String  :permalink, :text => true
      String  :url,       :text => true
    end
  end

  task :import do
    DB = Sequel.connect(ENV["DATABASE"])

    require_relative "comment"
    require_relative "link"

    DB.transaction do
      CSV.foreach("saved_items.csv", :headers => true) do |row|
        case row["kind"]
        when "t1"
          Comment.find_or_create(:reddit_id => row["reddit_id"]) { |c|
            c.kind       = row["kind"]
            c.name       = row["name"]
            c.subreddit  = row["subreddit"]
            c.body       = row["body"]
            c.link_id    = row["link_id"]
            c.link_title = row["link_title"]
            c.link_url   = row["link_url"]
          }
        when "t3"
          Link.find_or_create(:reddit_id => row["reddit_id"]) { |l|
            l.kind       = row["kind"]
            l.name       = row["name"]
            l.subreddit  = row["subreddit"]
            l.title      = row["title"]
            l.is_self    = row["is_self"]
            l.permalink  = row["permalink"]
            l.url        = row["url"]
          }
        end
      end
    end
  end

end
