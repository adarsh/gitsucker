module Gitsucker
  class Author
    STAT_TYPES = %w(name all originals forked ruby js score)

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def score
      scorer.score
    end

    def original_repo_count
      github_profile.original_repo_count
    end

    def forked_repo_count
      github_profile.forked_repo_count
    end

    def js_repo_count
      github_profile.js_repo_count
    end

    def ruby_repo_count
      github_profile.ruby_repo_count
    end

    def ==(other)
      if other.is_a?(Author)
        name == other.name
      else
        super
      end
    end

    private

    def github_profile
      GithubProfile.new(@name)
    end

    def scorer
      Scorer.new(original_repo_count, ruby_repo_count, js_repo_count, forked_repo_count)
    end
  end
end
