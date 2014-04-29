@announce
Feature: Help for define
  In order to learn about usage
  As a developer using Cucumber
  I run the help define command

  Scenario: Help command runs
    When I run `lyracyst help define`
    Then the output should contain "Uses the Wordnik API to get definitions"
    And the exit status should be 0
