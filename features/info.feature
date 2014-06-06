Feature: Info
  In order to use my app to get word info
  As a developer using Spinach
  I run the rb inf command

  Scenario: Info command runs
    When I run `lyracyst rb inf fuck`
    Then the output should contain word info
    And the exit status should be 0
