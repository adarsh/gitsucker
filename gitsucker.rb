#!/usr/bin/env ruby
# Libraries
require 'open-uri'
require 'nokogiri'
require 'json'

# Constants
GIT_REPO_SEARCH_URL = 'https://api.github.com/legacy/repos/search/'
GIT_API_URL = 'https://api.github.com/repos/'
GIT_USER_INFO_URL = 'https://api.github.com/users/'
GIT_USER_PROFILE_URL = 'https://github.com/'

class Query
  attr_accessor :forking_authors

  def initialize(repo_query)
    @repo_query = repo_query
  end

  def get_forking_authors
    collect_authors_array(get_all_forks_for_repo(@repo_query))
  end

  private

  def get_all_forks_for_repo(repo)
    author = get_author_using_repo_query(@repo_query)
    JSON.parse(open(GIT_API_URL + author + "/" + repo + "/forks").read)
  end

  def get_author_using_repo_query(query)
    results = JSON.parse(open(GIT_REPO_SEARCH_URL + query).read)
    results["repositories"].first["username"]
  end

  def collect_authors_array(forks)
    forking_authors = forks.collect { |fork| Author.new(fork["owner"]["login"]) }
    sort_authors_by_score(forking_authors)
  end

  def sort_authors_by_score(array_of_authors)
    array_of_authors.sort_by! { |a| -a.score }
  end
end

class Author
  attr_accessor :name, :all_projects, :originals, :forked, :ruby, :js, :score

  def initialize(author)
    self.name = author
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
    forking_authors = Query.new(input).get_forking_authors

    printf "%-20s %-10s %-10s %-10s %-10s %-10s %-10s",
      "name", "all", "originals", "forked", "ruby", "js", "score"

    puts
    print '='*80
    puts

    forking_authors.each do |author|
      printf "%-20s %-10s %-10s %-10s %-10s %-10s %-10s",
        author.name, author.all_projects, author.originals, author.forked,
        author.ruby, author.js, author.score
      puts
    end
  # rescue
    # puts "Repo not found."
  # end
end
