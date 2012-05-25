module Gitsucker
  class Repo
    def initialize(name)
      @repo_author_list = RepoAuthorList.new(name)
    end

    def forking_authors
      @repo_author_list.authors.sort_by(&:score).reverse
    end
  end
end
