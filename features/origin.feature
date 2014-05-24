@announce
Feature: Origin
  In order to use my app to get etymologies
  As a developer using Cucumber
  I run the origin command

  Scenario: Origin command runs
    When I run `lyracyst origin test`
    Then the output should contain an etymology
    And the exit status should be 0
