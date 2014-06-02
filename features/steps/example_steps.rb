class Spinach::Features::Example < Spinach::FeatureSteps
  step 'I run `lyracyst example test`' do
    @output = `lyracyst example test`
  end

  step 'the output should contain an example' do
    @output =~ /\[Example\]  - [A-Za-z0-9 ,:\-\='"+;\(\)\/\\.?&#|]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
