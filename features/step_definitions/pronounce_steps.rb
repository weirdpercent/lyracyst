Then(/^the output should contain a pronunciation$/) do
  @output = `lyracyst pronounce beautiful`
  @output =~ /\[Pronunciation\] - [A-Za-z0-9 \(\)͞oˈtə\-fəlū"tĭ*fụl͞]*/
  $?.exitstatus == 0
end
