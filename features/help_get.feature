@announce
Feature: Help for get
  In order to learn about usage
  As a developer using Cucumber
  I run the help get command

  Scenario: Help get command runs
    When I run `lyracyst help get`
    Then the output should contain "Searches definitions, related words, and rhymes for a given query"
    And the exit status should be 0
