Feature: Phrase
  In order to use my app to get phrases
  As a developer using Cucumber
  I run the phrase command

  Scenario: Phrase command runs
    When I run `lyracyst phrase test`
    Then the output should contain a phrase
    And the exit status should be 0
