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

  # Methods
  def initialize(repo)
    repo = repo
    author = determine_author(repo)
    fetch_repo_data(repo, author)
  end

  def number_of_repos
    @repo_data["forks"]
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
end

ARGV.each do |input|
  puts GithubRepo.new(input).number_of_repos
end
