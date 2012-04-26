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

class Author
  attr_accessor :name, :all_projects, :originals, :forked, :ruby, :js, :score

  def initialize(author)
    self.name = author
  end
end

class Query
  attr_accessor :forking_authors
  def initialize(repo)
    author = determine_author(repo)
    get_forking_authors(repo, author)
  end

  private

  def add_author_attributes(fork_author)
    user_page = fetch_user_profile(fork_author.name)

    fork_author.all_projects = public_repo_count(user_page)
    fork_author.originals    = original_repo_count(user_page)
    fork_author.forked       = forked_repo_count(user_page)
    fork_author.ruby         = ruby_repo_count(user_page)
    fork_author.js           = js_repo_count(user_page)

    add_score_to_author(fork_author)
  end

  def add_score_to_author(author)
    score = author.originals * 3
    score += author.ruby * 2
    score += author.js * 2
    score += author.forked * 1

    author.score = score
  end

  def determine_author(query)
    url = GIT_REPO_SEARCH_URL + query
    results = JSON.parse(open(url).read)
    results["repositories"].first["username"]
  end

  def fetch_user_profile(author)
    Nokogiri::HTML(open(GIT_USER_PROFILE_URL + author))
  end

  def forked_repo_count(page)
    public_repo_count(page) - original_repo_count(page)
  end

  def get_fork_data(repo, author)
    url = GIT_API_URL + author + "/" + repo + "/forks"
    content = open(url).read
    JSON.parse(open(url).read)
  end

  def get_forking_authors(repo, author)
    forks = get_fork_data(repo, author)

    @forking_authors = forks.collect do |fork|
      author_name = fork["owner"]["login"]
      fork_author = Author.new(author_name)
      add_author_attributes(fork_author)
      fork_author
    end

    sort_authors_by_score(@forking_authors)
  end

  def js_repo_count(page)
    page.css("ul.repo-stats").select{|li| li.text =~ /JavaScript/}.count
  end

  def original_repo_count(page)
    page.css(".source").count
  end

  def public_repo_count(page)
    page.css(".public").count
  end

  def ruby_repo_count(page)
    page.css("ul.repo-stats").select{|li| li.text =~ /Ruby/}.count
  end

  def sort_authors_by_score(array_of_objects)
    array_of_objects.sort_by! { |obj| -obj.score }
  end
end


# Command-Line Parsing
ARGV.each do |input|
  begin
    puts "Fetching data..."
    repo = Query.new(input)
    headers = ["all", "originals", "forked", "ruby", "js", "score"]
    printf "%-20s", "name"
    headers.each { |title| printf "%-10s", title }

    puts
    80.times { print '=' }
    puts

    repo.forking_authors.each do |author|
      printf "%-20s", author.name
      printf "%-10s", author.all_projects
      printf "%-10s", author.originals
      printf "%-10s", author.forked
      printf "%-10s", author.ruby
      printf "%-10s", author.js
      printf "%-10s", author.score
      puts
    end
  rescue
    puts "Repo not found."
  end
end
