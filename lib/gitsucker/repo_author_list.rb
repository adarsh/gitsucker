class RepoAuthorList
  def initialize(repo_name)
    @repo_name = repo_name
  end

  def authors
    @authors ||= author_names.map { Author.new(name) }
  end

  private

  def author_names
    JSON.parse(open(author_url).read).map { |fork| fork['owner']['login'] }
  end

  def author
    JSON.parse(open(search_url).read)['repositories'].first['username']
  end

  def author_url
    'https://api.github.com/repos/' + author + '/' + @repo_name + '/forks'
  end

  def search_url
    'https://api.github.com/legacy/repos/search/' + @repo_name
  end
end
