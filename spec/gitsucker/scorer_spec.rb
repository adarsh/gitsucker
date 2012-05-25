require 'spec_helper'

describe Gitsucker::Scorer, '#score' do
  it 'weights each attribute and adds them up' do
    original_repo_count = 1
    ruby_repo_count = 2
    js_repo_count = 3
    forked_repo_count = 4
    scorer = Gitsucker::Scorer.new(original_repo_count, ruby_repo_count, js_repo_count, forked_repo_count)
    expected_score = (original_repo_count * Gitsucker::Scorer::ORIGINAL_REPO_VALUE) +
                      (ruby_repo_count * Gitsucker::Scorer::RUBY_REPO_VALUE) +
                      (js_repo_count * Gitsucker::Scorer::JS_REPO_VALUE) +
                      (forked_repo_count * Gitsucker::Scorer::FORKED_REPO_VALUE)
    scorer.score.should == expected_score
  end
end

describe Gitsucker::Scorer, 'constants' do
  it 'values original repos correctly' do
    Gitsucker::Scorer::ORIGINAL_REPO_VALUE.should == 3
  end

  it 'values ruby repos correctly' do
    Gitsucker::Scorer::RUBY_REPO_VALUE.should == 2
  end

  it 'values JS repos correctly' do
    Gitsucker::Scorer::JS_REPO_VALUE.should == 2
  end

  it 'values forked repos correctly' do
    Gitsucker::Scorer::FORKED_REPO_VALUE.should == 1
  end
end
