#!/usr/bin/env ruby
require 'open-uri'
require 'json'
require './lib/author'
require './lib/repo'
require './lib/table'
require './lib/repo_author_list'

ORIGINAL_REPO_VALUE = 3
RUBY_REPO_VALUE = 2
JS_REPO_VALUE = 2
FORKED_REPO_VALUE = 1

ARGV.each do |input|
  table = Table.new(input)
  table.output_results
end
