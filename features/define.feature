Feature: Define
  In order to use my app to get definitions
  As a developer using Spinach
  I run the wn def command

  Scenario: Define command runs
    When I run `lyracyst wn def test`
    Then the output should contain definitions
    And the exit status should be 0
