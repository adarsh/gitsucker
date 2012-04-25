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

      user_page = Nokogiri::HTML(open(GIT_USER_PROFILE_URL + fork_author))

      all_projects = user_page.css(".public").count
      originals = user_page.css(".source").count
      forked = all_projects - originals

      ruby = user_page.css("ul.repo-stats").select{|li| li.text =~ /Ruby/}.count
      js = user_page.css("ul.repo-stats").select{|li| li.text =~ /JavaScript/}.count

      @forking_authors << {
        :fork_author => fork_author,
        :all_projects => all_projects,
        :originals => originals,
        :forked => forked,
        :ruby => ruby,
        :js => js
      }
    end

    @forking_authors
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
end

ARGV.each do |input|
  repo = GithubRepo.new(input)
  repo.fork_authors.each do |forking_author|
    forking_author.each do |key, value|
      if key == "js"
        print value.to_s
      else
        print value.to_s + ", "
      end
    end
    puts
  end
end
