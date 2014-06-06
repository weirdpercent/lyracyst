Feature: Relate
  In order to use my app to fetch related words
  As a developer using Spinach
  I run the wn rel command

  Scenario: Relate command runs
    When I run `lyracyst wn rel test`
    Then the output should contain related words
    And the exit status should be 0
