Feature: Rhyme
  In order to use my app to fetch rhymes
  As a developer using Cucumber
  I run the rhyme command

  Scenario: Rhyme command runs
    When I run `lyracyst rbrain rhyme orange`
    Then the output should contain rhymes
    And the exit status should be 0
