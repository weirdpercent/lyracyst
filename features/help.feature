Feature: Help
  In order to learn about my app's usage
  As a developer using Cucumber
  I run the help command

  Scenario: Help command runs
    When I run `lyracyst --help`
    Then the output should contain "A powerful word search tool that fetches definitions, related words, and rhymes."
    And the exit status should be 0
