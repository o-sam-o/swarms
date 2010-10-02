Feature: Match Torrents to Movies
  In order to display the correct movie stats
  as a site admin
  I want to verify torrent to movie mappings

  # FIXME this shouldnt need JS, but webrat doesnt seem to be passing the params correctly
  @javascript
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

  @wip
  Scenario: Correct a movie / torrent mapping
