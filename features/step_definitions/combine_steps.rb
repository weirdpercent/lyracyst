Then(/^the output should contain a portmanteau$/) do
  @output = `lyracyst combine test`
  @output =~ /\[Portmanteaus\] - [A-Za-z0-9:.,'| ]*/
  $?.exitstatus == 0
end
