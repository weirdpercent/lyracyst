@announce
Feature: Hyphenation
  In order to use my app to get hyphenations
  As a developer using Cucumber
  I run the hyphen command

  Scenario: Hyphenation command runs
    When I run `lyracyst hyphen communication`
    Then the output should contain a hyphenation
    And the exit status should be 0
