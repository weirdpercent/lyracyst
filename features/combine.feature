Feature: Combine
  In order to use my app to get portmanteaus
  As a developer using Spinach
  I run the rb comb command

  Scenario: Combine command runs
    When I run `lyracyst rb comb test`
    Then the output should contain a portmanteau
    And the exit status should be 0
