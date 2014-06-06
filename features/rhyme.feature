Feature: Rhyme
  In order to use my app to fetch rhymes
  As a developer using Spinach
  I run the rb rhy command

  Scenario: Rhyme command runs
    When I run `lyracyst rb rhy orange`
    Then the output should contain rhymes
    And the exit status should be 0
