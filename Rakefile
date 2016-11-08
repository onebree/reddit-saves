require "sequel"
require "dotenv"
require "csv"

Dotenv.load

namespace :db do
  task :setup do
    DB = Sequel.connect(ENV["DATABASE"])

    DB.create_table(:comments) do
      String :id,         :primary_key => true
      String :kind
      String :name
      String :subreddit
      String :link_id
      String :body,       :text => true
      String :link_title, :text => true
      String :link_url,   :text => true
    end

    DB.create_table(:links) do
      String  :id,        :primary_key => true
      String  :kind
      String  :name
      String  :subreddit
      Boolean :is_self
      String  :permalink, :text => true
      String  :url,       :text => true
      String  :title,     :text => true
    end
  end

  task :import do
    DB = Sequel.connect(ENV["DATABASE"])

    DB.transaction do
      comments = DB.from(:comments)
      links    = DB.from(:links)

      CSV.foreach("saved_items.csv", :headers => true) do |row|
        case row["kind"]
        when "t1"
          comments.insert(
            :id         => row["id"],
            :kind       => row["kind"],
            :name       => row["name"],
            :subreddit  => row["subreddit"],
            :link_id    => row["link_id"],
            :body       => row["body"],
            :link_title => row["link_title"],
            :link_url   => row["link_url"]
          )
        when "t3"
          links.insert(
            :id         => row["id"],
            :kind       => row["kind"],
            :name       => row["name"],
            :subreddit  => row["subreddit"],
            :is_self    => row["is_self"] == "true",
            :permalink  => row["permalink"],
            :url        => row["url"],
            :title      => row["title"]
          )
        end
      end
    end
  end
end
