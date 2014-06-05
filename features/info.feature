Feature: Info
  In order to use my app to get word info
  As a developer using Cucumber
  I run the info command

  Scenario: Info command runs
    When I run `lyracyst rbrain info fuck`
    Then the output should contain word information
    And the exit status should be 0
