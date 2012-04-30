#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'json'
require 'awesome_print'

GIT_USER_PROFILE_URL = 'https://github.com/'

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

  def fork_authors
    JSON.parse(open(author_url).read).map { |fork| fork["owner"]["login"] }
  end

  def author_url
    'https://api.github.com/repos/' + author + "/" + @name + "/forks"
  end

  def search_url
    'https://api.github.com/legacy/repos/search/' + @name
  end

  def author
    JSON.parse(open(search_url).read)["repositories"].first["username"]
  end
end

class Author
  attr_accessor :name, :all_projects, :originals, :forked, :ruby, :js, :score
  attr_reader :score

  def initialize(name)
    @name = name

    @score = original_repo_count * 3
    @score += ruby_repo_count * 2
    @score += js_repo_count * 2
    @score += forked_repo_count * 1

    self.add_author_attributes
  end

  def add_author_attributes

    self.all_projects = public_repo_count
    self.originals    = original_repo_count
    self.forked       = forked_repo_count
    self.ruby         = ruby_repo_count
    self.js           = js_repo_count
  end

  private

  def github_profile
    Nokogiri::HTML(open(GIT_USER_PROFILE_URL + @name))
  end

  def public_repo_count
    github_profile.css(".public").count
  end

  def original_repo_count
    github_profile.css(".source").count
  end

  def forked_repo_count
    public_repo_count - original_repo_count
  end

  def ruby_repo_count
    github_profile.css("ul.repo-stats").select{|li| li.text =~ /Ruby/}.count
  end

  def js_repo_count
    github_profile.css("ul.repo-stats").select{|li| li.text =~ /JavaScript/}.count
  end
end

# Command-Line Parsing
ARGV.each do |input|
  # begin
    puts "Fetching data..."
    puts "%-20s %-10s %-10s %-10s %-10s %-10s %-10s" %
      ["name", "all", "originals", "forked", "ruby", "js", "score"]

    print '='*80
    puts

    forking_authors = Repo.new(input).get_forking_authors
    forking_authors.each do |author|
      puts "%-20s %-10s %-10s %-10s %-10s %-10s %-10s" %
        [author.name, author.all_projects, author.originals, author.forked,
        author.ruby, author.js, author.score]
    end
  # rescue
    # puts "Repo not found."
  # end
end
