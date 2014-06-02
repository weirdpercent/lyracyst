class Spinach::Features::Urban < Spinach::FeatureSteps
  step 'I run `lyracyst urban hashtag`' do
    @output = `lyracyst urban hashtag`
  end

  step 'the output should contain an Urban Dictionary definition' do
    @output =~ /[A-Za-z0-9 ,'".-=?#>!\(\)\[\]|-]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
