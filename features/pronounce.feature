@announce
Feature: Pronounce
  In order to use my app to get pronunciations
  As a developer using Cucumber
  I run the pronounce command

  Scenario: Pronounce command runs
    When I run `lyracyst pronounce test`
    Then the output should contain a pronunciation
    And the exit status should be 0
