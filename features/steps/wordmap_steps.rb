class Spinach::Features::Wordmap < Spinach::FeatureSteps
  step 'I run `lyracyst wmap ubiquity`' do
    @output = `lyracyst wmap ubiquity`
  end

	step 'the output should contain each command' do
    @output =~ /[A-Za-z0-9 ,'"”ĭ…√©ˈēɪ—_.-=?#>!\(\)\[\]|-]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
