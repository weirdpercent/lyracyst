Then(/^the output should contain related words$/) do
  @output = `lyracyst relate test`
  @output =~ /\[Related words\] [A-Za-z0-9 \-,'ö]*/
  $?.exitstatus == 0
end
