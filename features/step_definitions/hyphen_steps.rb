Then(/^the output should contain a hyphenation$/) do
  @output = `lyracyst hyphen communication`
  @output =~ /\[Hyphenation\] - [a-z-]*/
  $?.exitstatus == 0
end
