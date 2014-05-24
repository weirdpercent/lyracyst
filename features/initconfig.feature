Feature: Initconfig
  In order to use my app to initialize configuration
  As a developer using Cucumber
  I run the initconfig command

  Scenario: Initconfig command runs
    When I run `lyracyst -h net_http_persistent -j json_pure -x rexml initconfig --force`
    Then the output should contain a confirmation
    And the exit status should be 0
