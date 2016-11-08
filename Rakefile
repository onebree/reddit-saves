require "sequel"
require "dotenv"

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
end
