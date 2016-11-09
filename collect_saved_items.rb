#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require "dotenv"
require "redditkit"
require "csv"
require "cgi"

Dotenv.load

@client = RedditKit::Client.new ENV["USERNAME"], ENV["PASSWORD"]

@after_id = nil

@paginated_results = []

def get_saved
  options = { :category => "saved", :limit => 100 }
  options[:after] = @after_id if @after_id

  results = @client.my_content(options).results

  return if results.empty?
  
  @paginated_results.push results

  results.last.attributes[:name]
end

loop do
  last_item_id = get_saved

  break if last_item_id.nil?

  @after_id = last_item_id
end

saved_items = @paginated_results.flatten

CSV.open("saved_items.csv", "w") do |csv|
  csv << [
    "name",  "kind",    "reddit_id",  "subreddit", # Comments and links
    "body",  "link_id", "link_title", "link_url",  # Comments only
    "title", "is_self", "permalink",  "url"        # Links only
  ]

  saved_items.each do |item|
    [:body, :link_title, :link_url, :url, :title].each do |key|
      if item.attributes.has_key?(key)
        item.attributes[key] = CGI.unescapeHTML(item.attributes[key])
      end
    end

    values = item.attributes.values_at(
      :name,  :kind,    :reddit_id,  :subreddit,
      :body,  :link_id, :link_title, :link_url,
      :title, :is_self, :permalink,  :url
    )

    csv << values
  end
end
