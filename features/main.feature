Feature: Use gitsucker to find engineers based on a github project
  In order to find engineers similar to a github project
  As a user
  I should be able to give a github project name and get back engineers

  Scenario Outline: Get github members who have forked a project
    Given I have a github repo called "fistface"
    When I enter the github repo name
    Then I should get "<author>, <all_projects>, <originals>, <forked>, <ruby>, <js>"

    Examples:
      | author     | all_projects | originals | forked | ruby | js |
      | garethrees | 2            | 1         | 1      | 1    | 1  |
      | caozhzh    | 2            | 1         | 1      | 1    | 1  |
      | mbleigh    | 2            | 1         | 1      | 1    | 1  |
      | donhill    | 2            | 1         | 1      | 1    | 1  |
