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

  def initialize(name)
    self.name = name
    self.add_author_attributes
  end

  def add_author_attributes
    user_page = fetch_user_profile(self.name)

    self.all_projects = public_repo_count(user_page)
    self.originals    = original_repo_count(user_page)
    self.forked       = forked_repo_count(user_page)
    self.ruby         = ruby_repo_count(user_page)
    self.js           = js_repo_count(user_page)

    add_score_to_author(self)
  end

  private

  def fetch_user_profile(author)
    Nokogiri::HTML(open(GIT_USER_PROFILE_URL + author))
  end

  def public_repo_count(page)
    page.css(".public").count
  end

  def original_repo_count(page)
    page.css(".source").count
  end

  def forked_repo_count(page)
    public_repo_count(page) - original_repo_count(page)
  end

  def ruby_repo_count(page)
    page.css("ul.repo-stats").select{|li| li.text =~ /Ruby/}.count
  end

  def js_repo_count(page)
    page.css("ul.repo-stats").select{|li| li.text =~ /JavaScript/}.count
  end

  def add_score_to_author(author)
    score = author.originals * 3
    score += author.ruby * 2
    score += author.js * 2
    score += author.forked * 1

    author.score = score
  end
end

# Command-Line Parsing
ARGV.each do |input|
  # begin
    puts "Fetching data..."
    forking_authors = Repo.new(input).get_forking_authors

    puts "%-20s %-10s %-10s %-10s %-10s %-10s %-10s" %
      ["name", "all", "originals", "forked", "ruby", "js", "score"]

    print '='*80
    puts

    forking_authors.each do |author|
      puts "%-20s %-10s %-10s %-10s %-10s %-10s %-10s" %
        [author.name, author.all_projects, author.originals, author.forked,
        author.ruby, author.js, author.score]
    end
  # rescue
    # puts "Repo not found."
  # end
end
