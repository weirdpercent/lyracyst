Feature: Related
  In order to use my app to fetch related words
  As a developer using Cucumber
  I run the related command

  Scenario: Related command runs
    When I run `lyracyst related test`
    Then the output should contain "Getting related words"
    And the exit status should be 0
