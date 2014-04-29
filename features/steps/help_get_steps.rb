class Spinach::Features::Help < Spinach::FeatureSteps
  step 'I run `lyracyst help get`' do
    @output = `lyracyst help get`
  end

  step 'the output should contain "Searches definitions, related words, and rhymes for a given query"' do
    @output =~ /\s*[A-Z]*:\s*[A-Za-z #,\s\-_\[\]\.]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
