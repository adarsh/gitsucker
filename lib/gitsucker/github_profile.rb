module Gitsucker
  class GithubProfile
    def initialize(username)
      @username = username
    end

    def forked_repo_count
      @forked ||= public_repo_count - original_repo_count
    end

    def js_repo_count
      @js ||= github_profile.css('ul.repo-stats').select{|li| li.text =~ /JavaScript/}.count
    end

    def original_repo_count
      @original ||= github_profile.css('.source').count
    end

    def public_repo_count
      @public_count ||= github_profile.css('.public').count
    end

    def ruby_repo_count
      @ruby ||= github_profile.css('ul.repo-stats').select{|li| li.text =~ /Ruby/}.count
    end

    private

    def github_profile
      @github_profile ||= Nokogiri::HTML(open('https://github.com/' + @username))
    end
  end
end
