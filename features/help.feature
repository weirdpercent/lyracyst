@announce
Feature: Help
  In order to learn about usage
  As a developer using Cucumber
  I run the help command

  Scenario: Help command runs
    When I get help for "lyracyst"
    And the output should contain "A powerful word search tool"
    And the exit status should be 0
