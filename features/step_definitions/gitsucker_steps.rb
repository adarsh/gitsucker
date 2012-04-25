Given /^I have a github repo called "([^']*)"$/ do |repo|
  @repo_query = repo
end

When /^I enter the github repo name$/ do
  @output = `ruby gitsucker.rb #{@repo_query}`
  raise('Command failed') unless $?.success?
end

Then /^I should get the appropriate output$/ do
  @output.should include("mbleigh")
  @output.should include("donhill")
  @output.should include("garethrees")
  @output.should include("caozhzh")
end
