#!/usr/bin/env ruby

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

  def author
    JSON.parse(open(search_url).read)['repositories'].first['username']
  end

  def author_url
    'https://api.github.com/repos/' + author + '/' + @name + '/forks'
  end

  def fork_authors
    JSON.parse(open(author_url).read).map { |fork| fork['owner']['login'] }
  end

  def search_url
    'https://api.github.com/legacy/repos/search/' + @name
  end
end
