Then(/^the output should contain word information$/) do
  @output = `lyracyst rbrain info fuck`
  @output =~ /\[Word info\] - [A-Za-z0-9: |ˈfʌk\.]*/
  $?.exitstatus == 0
end
