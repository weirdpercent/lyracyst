@announce
Feature: Relate
  In order to use my app to fetch related words
  As a developer using Cucumber
  I run the relate command

  Scenario: Relate command runs
    When I run `lyracyst relate test`
    Then the output should contain "Getting related words"
    And the output should contain "Related words"
    And the exit status should be 0