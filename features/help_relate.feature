@announce
Feature: Help for relate
  In order to learn about usage
  As a developer using Cucumber
  I run the help relate command

  Scenario: Help relate command runs
    When I run `lyracyst help relate`
    Then the output should contain "Uses the Altervista API to get related words"
    And the exit status should be 0
