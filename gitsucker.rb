#!/usr/bin/env ruby
require 'rubygems'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'json'

class GithubRepo
  # Constants
  GIT_REPO_SEARCH_URL = 'https://github.com/api/v2/xml/repos/search/'
  # switch for 'https://api.github.com/legacy/repos/search/:keyword'
  GIT_API_URL = 'https://api.github.com/repos/'
  GIT_USER_INFO_URL = 'https://api.github.com/users/'
  GIT_USER_PROFILE_URL = 'https://github.com/'

  # Methods
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

    @forking_authors = []

    forks.each do |fork|
      fork_author = fork["owner"]["login"]
      user_page = fetch_user_profile(fork_author)

      all_projects = public_repo_count(user_page)
      originals = original_repo_count(user_page)
      forked = all_projects - originals
      ruby = ruby_repo_count(user_page)
      js = js_repo_count(user_page)

      author_hash = {
        :fork_author  => fork_author,
        :all_projects => all_projects,
        :originals    => originals,
        :forked       => forked,
        :ruby         => ruby,
        :js           => js }

      author_hash = score_author(author_hash)
      @forking_authors << author_hash
    end
  end

  private

  def determine_author(query)
    url = GIT_REPO_SEARCH_URL + query
    results = Nokogiri::XML(open(url))
    first_search_result_username = results.css("username").first.content
  end

  def fetch_repo_data(repo, author)
    url = GIT_API_URL + author + "/" + repo
    content = open(url).read
    @repo_data = JSON.parse(content)
  end

  def fetch_user_profile(author)
    Nokogiri::HTML(open(GIT_USER_PROFILE_URL + author))
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
    author[:score] = "999"
    author
  end
end

# Command-Line Parsing
ARGV.each do |input|
  repo = GithubRepo.new(input)
  puts "Username/projects/original/forked/ruby/js/score"

  repo.fork_authors.each do |forking_author|

    forking_author.each do |key, value|
      print value.to_s
      if key == :score
        puts
      else
        print ", "
      end
    end
  end
end
