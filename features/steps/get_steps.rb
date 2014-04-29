class Spinach::Features::Get < Spinach::FeatureSteps
  step 'I run `lyracyst get test`' do
    @output = `lyracyst get test`
  end

  step 'the output should contain "Getting all"' do
    @output =~ /Getting all for \[[A-Za-z\-' ]*\]/
  end

  step 'the output should contain "Definition"' do
    @output =~ /Definition: [a-z-]* - [A-Za-z0-9,.;':"” \-\(\)]*/
  end

  step 'the output should contain "Related words"' do
    @output =~ /Related words: [a-z-]* - [a-z\-' |]*/
  end

  step 'the output should contain "Rhymes with"' do
    @output =~ /Rhymes with: [a-z0-9\-' ]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
