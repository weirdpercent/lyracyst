Then(/^the output should contain an etymology$/) do
  @output = `lyracyst wordnik origin test`
  @output =~ /\[Etymology\] - [A-Za-z0-9\[\]. ,;\(\)-|√™t†t√™e]*/
  $?.exitstatus == 0
end
