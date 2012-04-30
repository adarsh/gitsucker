#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'json'

class Repo
  attr_accessor :forking_authors

  def initialize(name)
    @name = name
  end

  def get_forking_authors
    fork_authors.
      map { |name| Author.new(name) }.
      sort_by { |author| author.score }.
      reverse
  end

  private

  def author
    JSON.parse(open(search_url).read)['repositories'].first['username']
  end

  def author_url
    'https://api.github.com/repos/' + author + '/' + @name + '/forks'
  end

  def fork_authors
    JSON.parse(open(author_url).read).map { |fork| fork['owner']['login'] }
  end

  def search_url
    'https://api.github.com/legacy/repos/search/' + @name
  end
end

class Author
  attr_reader :score

  def initialize(name)
    @name = name
    @score = original_repo_count * 3
    @score += ruby_repo_count * 2
    @score += js_repo_count * 2
    @score += forked_repo_count * 1
  end

  def stats
    [
      @name,
      public_repo_count,
      original_repo_count,
      forked_repo_count,
      ruby_repo_count,
      js_repo_count,
      @score
    ]
  end

  def self.stat_types
    %w(name all originals forked ruby js score)
  end

  private

  def forked_repo_count
    @forked ||= public_repo_count - original_repo_count
  end

  def github_profile
    @github_profile ||= Nokogiri::HTML(open('https://github.com/' + @name))
  end

  def js_repo_count
    @js ||= github_profile.css('ul.repo-stats').select{|li| li.text =~ /JavaScript/}.count
  end

  def original_repo_count
    @original ||= github_profile.css('.source').count
  end

  def public_repo_count
    @public_count ||= github_profile.css('.public').count
  end

  def ruby_repo_count
    @ruby ||= github_profile.css('ul.repo-stats').select{|li| li.text =~ /Ruby/}.count
  end
end

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
