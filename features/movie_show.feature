Feature: Movie Show Page Feature
  In order to find out more about a movie
  as a user
  I want to a detailed page for each movie

  Scenario: Visit movie show page
    Given the following movies exist:
      | name   | year | current_rank | plot               | genres |
      | Avatar | 2009 | 1            | FernGully in space | sci-fi |
    When I am on the home page
    And I follow "Avatar (2009)"
    Then I should be on the "Avatar" movie page
    And I should see "Avatar (2009)"
    And I should see "FernGully in space"
    And I should see "sci-fi"
