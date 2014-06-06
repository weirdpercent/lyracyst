Feature: Urban
  In order to use my app to get definitions
  As a developer using Spinach
  I run the urb command

  Scenario: Define command runs
    When I run `lyracyst urb hashtag`
    Then the output should contain an Urban Dictionary definition
    And the exit status should be 0
