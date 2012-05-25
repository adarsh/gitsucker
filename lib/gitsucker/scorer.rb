module Gitsucker
  class Scorer
    ORIGINAL_REPO_VALUE = 3
    RUBY_REPO_VALUE = 2
    JS_REPO_VALUE = 2
    FORKED_REPO_VALUE = 1

    def initialize(original_repo_count, ruby_repo_count, js_repo_count, forked_repo_count)
      @original_repo_count = original_repo_count
      @ruby_repo_count = ruby_repo_count
      @js_repo_count = js_repo_count
      @forked_repo_count = forked_repo_count
    end

    def score
      @original_repo_count * ORIGINAL_REPO_VALUE +
        @ruby_repo_count * RUBY_REPO_VALUE +
        @js_repo_count * JS_REPO_VALUE +
        @forked_repo_count * FORKED_REPO_VALUE
    end
  end
end
