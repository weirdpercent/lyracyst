Feature: Define
  In order to use my app to get definitions
  As a developer using Cucumber
  I run the define command

  Scenario: Define command runs
    When I run `lyracyst wordnik define test`
    Then the output should contain a definition
    And the exit status should be 0
