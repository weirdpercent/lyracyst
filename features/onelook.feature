Feature: Onelook
  In order to use my app to get word info
  As a developer using Spinach
  I run the look command

  Scenario: Look command runs
    When I run `lyracyst look test`
    Then the output should contain Onelook word info
    And the exit status should be 0
