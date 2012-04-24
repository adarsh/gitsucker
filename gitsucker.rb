#!/usr/bin/env ruby
require 'rubygems'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'json'

class GithubRepo
  # Constants
  GIT_REPO_SEARCH_URL = 'https://github.com/api/v2/xml/repos/search/'
  GIT_API_URL = 'https://api.github.com/repos/'
  GIT_USER_URL = 'https://api.github.com/users/'

  # Methods
  def initialize(repository)
    repo = repository
    author = determine_author(repo)
    get_fork_authors(repo, author)
  end

  def fork_authors
    @forking_authors
  end

  def get_fork_authors(repo, author)
    forks = get_fork_data(repo, author)

    @forking_authors = []

    forks.each do |fork|
      fork_author = fork["owner"]["login"]
      originals = 1
      forked = 1
      all_projects = originals + forked
      ruby = 1
      js = 1
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

  def get_fork_data(repo, author)
    url = GIT_API_URL + author + "/" + repo + "/forks"
    content = open(url).read
    JSON.parse(open(url).read)
  end
end

ARGV.each do |input|
  repo = GithubRepo.new(input)
  # puts repo.fork_authors.inspect
  repo.fork_authors.each do |forking_author|
    forking_author.each do |key, value|
      puts "#{key}: #{value}"
    end
    puts
  end
end
