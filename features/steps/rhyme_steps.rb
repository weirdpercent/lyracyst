class Spinach::Features::Rhyme < Spinach::FeatureSteps
  step 'I run `lyracyst rhyme test`' do
    @output = `lyracyst rhyme test`
  end

  step 'the output should contain "Getting rhymes"' do
    @output =~ /Getting rhymes/
  end

  step 'the output should contain "Rhymes with"' do
    @output =~ /Rhymes with: [a-z0-9\-' ]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
