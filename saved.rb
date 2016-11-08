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
    "name", "kind", "id", "subreddit",            # Comments and links
    "link_id", "body", "link_title", "link_url",  # Comments only
    "is_self", "permalink", "url", "title"        # Links only
  ]

  saved_items.each do |item|
    [:body, :link_title, :link_url, :url, :title].each do |key|
      if item.attributes.has_key?(key)
        item.attributes[key] = CGI.unescapeHTML(item.attributes[key])
      end
    end

    values = item.attributes.values_at(
      :name, :kind, :id, :subreddit,
      :link_id, :body, :link_title, :link_url,
      :is_self, :permalink, :url, :title
    )

    csv << values
  end
end
