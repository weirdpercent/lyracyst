Feature: Initconfig
  In order to use my app to initialize configuration
  As a developer using Cucumber
  I run the initconfig command

  Scenario: Initconfig command runs
    When I run `lyracyst -h net_http_persistent -j oj -x rexml initconfig --force`
    Then the output should contain a confirmation
    And the configuration file should exist
    And the exit status should be 0
