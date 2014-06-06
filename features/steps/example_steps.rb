class Spinach::Features::Example < Spinach::FeatureSteps
  step 'I run `lyracyst wn ex test`' do
    @output = `lyracyst wn ex test`
  end

  step 'the output should contain an example' do
    @output =~ /\[Example\]  - [A-Za-z0-9 ,:\-\='"+;\(\)\/\\.?&#|]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
