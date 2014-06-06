Feature: Phrase
  In order to use my app to get phrases
  As a developer using Spinach
  I run the wn phr command

  Scenario: Phrase command runs
    When I run `lyracyst wn phr test`
    Then the output should contain a phrase
    And the exit status should be 0
