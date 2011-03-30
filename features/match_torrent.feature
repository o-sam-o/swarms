Feature: Match Torrents to Movies
  In order to display the correct movie stats
  as a site admin
  I want to verify torrent to movie mappings

  Scenario: Verify movie and torrent match
    Given the following movies exist:
      | name    | year |
      | Top Gun | 1986 |
    And the following torrents exist:
      | name             | movie   | verified |
      | top.gunz.torrent | Top Gun | false    |
      | top.guys.torrent | Top Gun | false    |
    When I am on the verify torrent page
    Then I should see "top.gunz.torrent"
    And I should see "Top Gun"
    And I should see "top.guys.torrent"
    When I check "Verify top.gunz.torrent"
    And press "Verify"
    Then I should not see "top.gunz.torrent"
    And I should see "top.guys.torrent"

  @javascript
  Scenario: Correct a movie / torrent mapping to a movie that already exists
    Given the following movies exist:
      | name        | year | imdb_id |
      | Top Gun     | 1986 | fake_1  |
      | Top Gunner  | 1990 | fake_2  |
    And the following torrents exist:
      | name             | movie      | verified |
      | top.gunz.torrent | Top Gun    | false    |
      | top.guys.torrent | Top Gunner | false    |
    And I stub the IMDB search to return:
      | name        | year | imdb_id |
      | Top Gun     | 1986 | fake_1  |
      | Not Top Gun | 1981 | fake_3  |
    When I am on the verify torrent page
    And I opt to change the movie matching the torrent "top.guys.torrent"
    And I fill in "Movie Name:" with "Top Gun"
    And I press "Search" on the change movie dialog
    Then I should see "Top Gun" in the change movie results
    And I follow "Use"
    #When I use the "Top Gun" change movie result
    And press "Verify"
    Then I should see "top.gunz.torrent"
    And I should not see "top.guys.torrent"
    And I should have the following torrents:
     | name             | movie   | verified |
     | top.gunz.torrent | Top Gun | false    |
     | top.guys.torrent | Top Gun | true     |
