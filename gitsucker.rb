#!/usr/bin/env ruby

class GithubRepo
  # Constants
  GIT_REPO_SEARCH_URL = 'https://github.com/api/v2/xml/repos/search/'
  GIT_API_URL = 'https://api.github.com/repos/'

  def initialize(repo)
    @repo = repo
  end

  def number_of_repos
    6
  end
end

ARGV.each do |input|
  puts GithubRepo.new(input).number_of_repos
end
