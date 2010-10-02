Feature: Swarms Home Page
  In order to find new movies to watch
  as a user
  I want a landing page the summaries available movies

  Scenario: View movies by rank
    Given the following movies exist:
      | name          | year | current_rank |
      | Top Gun       | 1986 | 6            |
      | Primer        | 2004 | 100          |
      | Avatar        | 2009 | 1            |
      | Star Wars     | 1977 | 0            |
     When I am on the home page
     Then the 1st movie should be "Avatar (2009)"
     And the 2nd movie should be "Top Gun (1986)"
     And the 3rd movie should be "Primer (2004)"
     And I should not see "Star Wars"

  Scenario: Movie pagination
    Given there are 25 movies
    When I am on the home page
    Then I should see 15 movies
    And I should see "Movie Ranked 1 (2000)"
    And I should not see "Movie Ranked 16 (2000)"
    And I should see "Page 1 of 2"
    When I follow "2"
    Then I should see 10 movies
    Then I should see "Movie Ranked 16 (2000)"
    And I should not see "Movie Ranked 1 (2000)"
    And I should see "Page 2 of 2"

  Scenario: Search by genre
    Given the following movies exist:
      | name          | year | current_rank | genres  |
      | Top Gun       | 1986 | 6            | action  |
      | Primer        | 2004 | 100          | sci-fi  |
      | Avatar        | 2009 | 1            | sci-fi  |
      | Star Wars     | 1977 | 2            | sci-fi  |
     When I am on the home page
     Then I should see "Top Gun" within ".movie_tiles"
     And I should see "Primer" within ".movie_tiles"
     And I should see "Avatar" within ".movie_tiles"
     And I should see "Star Wars" within ".movie_tiles"
     Given I follow "action"
     Then I should see "Top Gun" within ".movie_tiles"
     And I should not see "Primer" within ".movie_tiles"
     Given I follow "sci-fi"
     Then I should see "Primer" within ".movie_tiles"
     And I should not see "Top Gun" within ".movie_tiles"

  Scenario: Search by name
    Given the following movies exist:
      | name          | year | current_rank | genres  |
      | Top Gun       | 1986 | 6            | action  |
      | Top Brass     | 1980 | 0            | action  |
      | Primer        | 2004 | 100          | sci-fi  |
    When I am on the home page
    Then I should see "Top Gun" within ".movie_tiles"
    And I should see "Primer" within ".movie_tiles"
    And I should not see "Top Brass" within ".movie_tiles"
    When I fill in "q" with "Top"
    And I press "Search"
    Then I should see "Top Gun" within ".movie_tiles"
    And I should see "Top Brass" within ".movie_tiles"
    And I should not see "Primer" within ".movie_tiles"

  Scenario: Search and get an exact match
    Given the following movies exist:
      | name          | year | current_rank | genres  |
      | Top Gun       | 1986 | 6            | action  |
      | Primer        | 2004 | 100          | sci-fi  |
    When I am on the home page
    Then I should see "Top Gun" within ".movie_tiles"
    And I should see "Primer" within ".movie_tiles"
    When I fill in "q" with "Primer"
    And I press "Search"
    Then I should be on the "Primer" movie page

  @wip
  Scenario: Youtube trailer

  @wip
  Scenario: Custom download link
