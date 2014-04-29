@announce
Feature: Get
  In order to use my app to the fullest
  As a developer using Cucumber
  I run the get command

  Scenario: Get command runs
    When I run `lyracyst get test`
    Then the output should contain "Getting all"
    And the output should contain "Definition"
    And the output should contain "Related words"
    And the output should contain "Rhymes with"
    And the exit status should be 0
