require 'spec_helper'

describe Gitsucker::RepoAuthorList do
  let(:repo_name) { 'kangaroo' }
  it 'shows correct authors' do
    stub_github_repo_name_authors(repo_name, %w(one two))
    repo_author_list = Gitsucker::RepoAuthorList.new(repo_name)
    repo_author_list.authors.should == [Gitsucker::Author.new('one'),
                                        Gitsucker::Author.new('two')]
  end

  def stub_github_repo_name_authors(repo_name, authors)
    ShamRack.at('api.github.com', 443).sinatra do
      authors.each do |author|
        get "/repos/#{author}/#{repo_name}/forks" do
          owner_hashes = authors.map do |login|
            { :owner => { :login => login } }
          end
          JSON.dump(owner_hashes)
        end
      end

      get "/legacy/repos/search/#{repo_name}" do
        usernames = authors.map { |author| { :username => author } }
        JSON.dump({ :repositories => usernames })
      end
    end
  end
end
