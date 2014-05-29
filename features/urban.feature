Feature: Urban
  In order to use my app to get definitions
  As a developer using Cucumber
  I run the urban command

  Scenario: Define command runs
    When I run `lyracyst urban hashtag`
    Then the output should contain an Urban Dictionary definition
    And the exit status should be 0
