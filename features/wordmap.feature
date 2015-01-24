Feature: Wordmap
  In order to use my app to get a map of word info
  As a developer using Spinach
  I run the wmap command

  Scenario: Wordmap command runs
    When I run `lyracyst wmap ubiquity`
    Then the output should contain each command
    And the exit status should be 0
