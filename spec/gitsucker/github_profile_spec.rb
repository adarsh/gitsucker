require 'spec_helper'

describe Gitsucker::GithubProfile do
  let(:username) { 'adarshpandit' }

  before do
    stub_out_github_for(username)
  end

  it 'returns the correct number of forks' do
    github_profile = Gitsucker::GithubProfile.new(username)
    github_profile.forked_repo_count.should == 1
  end

  it 'returns the correct number of sources' do
    github_profile = Gitsucker::GithubProfile.new(username)
    github_profile.original_repo_count.should == 1
  end

  it 'returns the correct number of Ruby repos' do
    github_profile = Gitsucker::GithubProfile.new(username)
    github_profile.ruby_repo_count.should == 1
  end

  it 'returns the correct number of JS repos' do
    github_profile = Gitsucker::GithubProfile.new(username)
    github_profile.js_repo_count.should == 1
  end

  def stub_out_github_for(username)
    file_path = File.expand_path('../../fixtures/github_profile.html', __FILE__)
    ShamRack.at('github.com', 443).sinatra do
      get "/#{username}" do
        [200, { "Content-Type" => "text/html" }, File.new(file_path)]
      end
    end
  end
end
