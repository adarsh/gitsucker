require 'spec_helper'

describe Gitsucker::Repo, '#forking_authors' do
  it 'returns repo authors reverse-sorted by score' do
    name = 'my-repo'

    low_score_author = stub('author one', :score => 1)
    high_score_author = stub('author two', :score => 2)
    authors = [low_score_author, high_score_author]

    author_list_instance = stub('author list', :authors => authors)
    Gitsucker::RepoAuthorList.stubs(:new).with(name).returns(author_list_instance)
    repo = Gitsucker::Repo.new(name)
    repo.forking_authors.should == [high_score_author, low_score_author]
  end
end
