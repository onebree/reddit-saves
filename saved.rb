#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require "dotenv"
require "redditkit"

Dotenv.load

@client = RedditKit::Client.new ENV["USERNAME"], ENV["PASSWORD"]

@after_id = nil

@paginated_results = []

def get_saved
  options = { :category => "saved", :limit => 100 }
  options[:after] = @after_id if @after_id

  results = @client.my_content(options).results

  return nil if results.empty?
  
  @paginated_results.push results

  results.last.attributes[:name]
end

loop do
  last_item_id = get_saved

  break if last_item_id.nil?

  @after_id = last_item_id
end

puts @paginated_results.length
