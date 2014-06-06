class Spinach::Features::Rhyme < Spinach::FeatureSteps
  step 'I run `lyracyst rb rhy orange`' do
    @output = `lyracyst rb rhy orange`
  end

  step 'the output should contain rhymes' do
    @output =~ /\[Rhymes\] - [a-z|]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
