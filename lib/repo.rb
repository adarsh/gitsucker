class Repo
  def initialize(name)
    @name = name
    @repo_author_list = RepoAuthorList.new(@name)
  end

  def forking_authors
    @repo_author_list.authors.sort_by(&:score).reverse
  end
end
