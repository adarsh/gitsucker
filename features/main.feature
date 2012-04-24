Feature: Use gitsucker to find engineers based on a github project
  In order to find engineers similar to a github project
  As a user
  I should be able to give a github project name and get back engineers

  Scenario Outline: Get github members who have forked a project
    Given I have a github repo called "<repo>"
    When I enter the github repo name
    Then I should get <number_of_forks> forks

    Examples:
      | repo     | number_of_forks |
      | fistface | 6               |
