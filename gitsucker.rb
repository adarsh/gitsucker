#!/usr/bin/env ruby
require 'net/http'
require 'open-uri'
require 'json'

class GithubRepo
  # Constants
  GIT_REPO_SEARCH_URL = 'https://github.com/api/v2/xml/repos/search/'
  GIT_API_URL = 'https://api.github.com/repos/'

  def initialize(repo)
    @repo = repo
    @author = 'thoughtbot'
  end

  def number_of_repos
    url = GIT_API_URL + @author + "/" + @repo
    content = open(url).read
    data = JSON.parse(content)
    data["forks"]
  end
end

ARGV.each do |input|
  puts GithubRepo.new(input).number_of_repos
end
