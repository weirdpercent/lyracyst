@announce
Feature: Help for rhyme
  In order to use my app to get definitions
  As a developer using Cucumber
  I run the help rhyme command

  Scenario: Help rhyme command runs
    When I run `lyracyst help rhyme`
    Then the output should contain "Uses the ARPABET system to get rhymes"
    And the exit status should be 0
