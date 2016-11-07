#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require "dotenv"
require "redditkit"

Dotenv.load

client = RedditKit::Client.new ENV["USERNAME"], ENV["PASSWORD"]

content = client.my_content(:category => "saved", :limit => 100)

subreddits = content.group_by { |x| x.attributes[:subreddit] }

puts subreddits.keys
