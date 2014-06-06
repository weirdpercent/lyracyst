Feature: Hyphenation
  In order to use my app to get hyphenations
  As a developer using Spinach
  I run the wn hyph command

  Scenario: Hyphenation command runs
    When I run `lyracyst wn hyph communication`
    Then the output should contain a hyphenation
    And the exit status should be 0
