class Spinach::Features::Help < Spinach::FeatureSteps
  step 'I run `lyracyst help get`' do
    @output = `lyracyst help get`
  end

  step 'the output should contain "Uses the Altervista API to get related words"' do
    @output =~ /\s*[A-Z]*:\s*[A-Za-z #,\s\-_\[\]\.]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
