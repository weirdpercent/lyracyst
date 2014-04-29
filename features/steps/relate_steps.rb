class Spinach::Features::Related < Spinach::FeatureSteps
  step 'I run `lyracyst relate test`' do
    @output = `lyracyst relate test`
  end

  step 'the output should contain "Getting related words"' do
    @output =~ /Getting related words for \[[A-Za-z\-' ]*\]/
  end

  step 'the output should contain "Related words"' do
    @output =~ /Related words: [a-z-]* - [a-z\-' |]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
