#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require "dotenv"
require "redditkit"
require "csv"

Dotenv.load

@client = RedditKit::Client.new ENV["USERNAME"], ENV["PASSWORD"]

@after_id = nil

@paginated_results = []

def raw_json(string)
  return if string.nil?

  string.gsub("&lt;", "<")
        .gsub("&gt;", ">")
        .gsub("&amp;", "&")
end

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
    item.attributes[:body]       = raw_json(item.attributes[:body])
    item.attributes[:link_title] = raw_json(item.attributes[:link_title])
    item.attributes[:link_url]   = raw_json(item.attributes[:link_url])
    item.attributes[:url]        = raw_json(item.attributes[:url])
    item.attributes[:title]      = raw_json(item.attributes[:title])

    values = item.attributes.values_at(
      :name, :kind, :id, :subreddit,
      :link_id, :body, :link_title, :link_url,
      :is_self, :permalink, :url, :title
    )

    csv << values
  end
end
