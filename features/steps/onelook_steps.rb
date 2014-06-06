class Spinach::Features::Onelook < Spinach::FeatureSteps
  step 'I run `lyracyst look test`' do
    @output = `lyracyst look test`
  end

  step 'the output should contain Onelook word info' do
    @output =~ /[\[\]A-Za-z0-9|'" :,\(\)]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
