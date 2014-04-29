class Spinach::Features::Help < Spinach::FeatureSteps
  step 'I run `lyracyst --help`' do
    @output = `lyracyst --help`
  end

  step 'the output should contain "A powerful word search tool"' do
    @output =~ /\s*[A-Z]*:\s*[A-Za-z #,\s\-_\[\]\.]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
