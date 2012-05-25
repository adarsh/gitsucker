require 'spec_helper'

describe Gitsucker, 'constants' do
  it 'values original repos correctly' do
    Gitsucker::ORIGINAL_REPO_VALUE.should == 3
  end

  it 'values ruby repos correctly' do
    Gitsucker::RUBY_REPO_VALUE.should == 2
  end

  it 'values JS repos correctly' do
    Gitsucker::JS_REPO_VALUE.should == 2
  end

  it 'values forked repos correctly' do
    Gitsucker::FORKED_REPO_VALUE.should == 1
  end
end
