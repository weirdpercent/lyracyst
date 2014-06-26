Feature: Anagram
  In order to use my app to get anagrams
  As a developer using Spinach
  I run the ana command

  Scenario: Anagram command runs
    When I run `lyracyst ana warrenpicketcalender`
    Then the output should contain anagrams
    And the exit status should be 0
