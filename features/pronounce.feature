Feature: Pronounce
  In order to use my app to get pronunciations
  As a developer using Spinach
  I run the wn pro command

  Scenario: Pronounce command runs
    When I run `lyracyst wn pro beautiful`
    Then the output should contain a pronunciation
    And the exit status should be 0
