Feature: Example
  In order to use my app to get example usage
  As a developer using Spinach
  I run the wn ex command

  Scenario: Example command runs
    When I run `lyracyst wn ex test`
    Then the output should contain an example
    And the exit status should be 0
