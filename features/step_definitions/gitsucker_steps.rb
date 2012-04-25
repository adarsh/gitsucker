Given /^I have a github repo called "([^']*)"$/ do |repo|
  @repo_query = repo
end

When /^I enter the github repo name$/ do
  @output = `ruby gitsucker.rb #{@repo_query}`
  raise('Command failed') unless $?.success?
end

Then /^I should get the appropriate output$/ do
  @output.should include("garethrees, 33, 24, 9, 18, 3")
  @output.should include("caozhzh, 9, 5, 4, 7, 0")
  @output.should include("mbleigh, 64, 36, 28, 51, 5")
  @output.should include("donhill, 14, 1, 13, 6, 0")
end
