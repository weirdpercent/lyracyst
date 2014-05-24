Feature: Example
  In order to use my app to get example usage
  As a developer using Cucumber
  I run the example command

  Scenario: Example command runs
    When I run `lyracyst example test`
    Then the output should contain an example
    And the exit status should be 0
