class Spinach::Features::Urban < Spinach::FeatureSteps
  step 'I run `lyracyst urb hashtag`' do
    @output = `lyracyst urb hashtag`
  end

  step 'the output should contain an Urban Dictionary definition' do
    @output =~ /[A-Za-z0-9 ,'".-=?#>!\(\)\[\]|-]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
