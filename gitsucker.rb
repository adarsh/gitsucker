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
  def initialize(repository)
    repo = repository
    author = determine_author(repo)
    get_forking_authors(repo, author)
  end

  def fork_authors
    @forking_authors
  end

  def get_forking_authors(repo, author)
    forks = get_fork_data(repo, author)

    @forking_authors = forks.collect do |fork|
      create_author_hash(fork["owner"]["login"])
    end

    sort_authors
  end

  private

  def create_author_hash(fork_author)
    user_page = fetch_user_profile(fork_author)

    author_hash = {
      :fork_author  => fork_author,
      :all_projects => public_repo_count(user_page),
      :originals    => original_repo_count(user_page),
      :forked       => forked_repo_count(user_page),
      :ruby         => ruby_repo_count(user_page),
      :js           => js_repo_count(user_page) }

    score_author(author_hash)
  end

  def determine_author(query)
    url = GIT_REPO_SEARCH_URL + query
    content = open(url).read
    results = JSON.parse(content)
    first_search_result_username = results["repositories"].first["username"]
  end

  def fetch_repo_data(repo, author)
    url = GIT_API_URL + author + "/" + repo
    content = open(url).read
    @repo_data = JSON.parse(content)
  end

  def fetch_user_profile(author)
    Nokogiri::HTML(open(GIT_USER_PROFILE_URL + author))
  end

  def forked_repo_count(page)
    public_repo_count(page) - original_repo_count(page)
  end

  def get_author_info(author)
    url = GIT_USER_INFO_URL + author
    content = open(url).read
    JSON.parse(content)
  end

  def get_fork_data(repo, author)
    url = GIT_API_URL + author + "/" + repo + "/forks"
    content = open(url).read
    JSON.parse(open(url).read)
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

  def score_author(author)
    score = author[:originals] * 3
    score = author[:ruby] * 2
    score = author[:js] * 2
    score = author[:forked] * 1

    author[:score] = score
    author
  end

  def sort_authors
    @forking_authors = @forking_authors.sort_by { |hsh| -hsh[:score] }
  end
end


# Command-Line Parsing
ARGV.each do |input|
  puts "Fetching data..."
  repo = Query.new(input)

  repo.fork_authors.first.each do |key, value|
    printf "%-13s", key
  end

  puts
  85.times { print '=' }
  puts

  repo.fork_authors.each do |forking_author|
    forking_author.each do |key, value|
      printf "%-13s", value.to_s
    end

    puts
  end
end
