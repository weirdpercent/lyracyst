Feature: Origin
  In order to use my app to get etymologies
  As a developer using Spinach
  I run the wn ori command

  Scenario: Origin command runs
    When I run `lyracyst wn ori test`
    Then the output should contain an etymology
    And the exit status should be 0
