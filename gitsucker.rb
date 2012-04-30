#!/usr/bin/env ruby
require './lib/author'
require './lib/repo'
require 'open-uri'
require 'json'

ORIGINAL_REPO_VALUE = 3
RUBY_REPO_VALUE = 2
JS_REPO_VALUE = 2
FORKED_REPO_VALUE = 1

ARGV.each do |input|
  begin
    puts 'Fetching data...'
    puts '%-20s %-10s %-10s %-10s %-10s %-10s %-10s' % Author.stat_types

    print '='*80
    puts

    Repo.new(input).get_forking_authors.each do |author|
      puts '%-20s %-10s %-10s %-10s %-10s %-10s %-10s' % author.stats
    end
  rescue
    puts 'Repo not found.'
  end
end
