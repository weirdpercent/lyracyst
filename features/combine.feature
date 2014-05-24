@announce
Feature: Combine
  In order to use my app to get portmanteaus
  As a developer using Cucumber
  I run the combine command

  Scenario: Combine command runs
    When I run `lyracyst combine test`
    Then the output should contain a portmanteau
    And the exit status should be 0
