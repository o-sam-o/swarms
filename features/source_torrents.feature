Feature: Source torrents and movie info
  In order display popular movies
  as a site admin
  I want the site to scrap torrent information and match it to the correct movie

  Scenario: Scrap and source movie info for 1 torrent
    Given I stub the pirate bay scraper to find
      | torrent_url                                                             | seeds | leaches |
      | http://example.com/The_Fighter[2010]DvDrip[Eng]-FXG.6210306.TPB.torrent | 100   | 250     |
    And I stub IMDB to have the following movies
      | title       | year  |
      | The Fighter | 2010  |
    When I source torrents
    Then I should have the follow movies
      | movie_name  | movie_year | swarm_score | current_rank |
      | The Fighter | 2010       | 350         | 1            |
    And I should have the following torrent stats
      | torrent_name                                         | movie_name  | seeds | leaches | swarm_size |
      | The_Fighter[2010]DvDrip[Eng]-FXG.6210306.TPB.torrent | The Fighter | 100   | 250     | 350        |

  Scenario: Scrap and source movie info for multiple movies
    Given I stub the pirate bay scraper to find
      | torrent_url                                                                    | seeds | leaches |
      | http://example.com/The_Fighter[2010]DvDrip[Eng]-FXG.6210306.TPB.torrent        | 100   | 250     |
      | http://example.com/The_Fighter_(2010)_DVDRip_XviD-MAX.6209036.TPB.torrent      | 10    | 50      |
      | http://example.com/Battle.Los.Angeles.2011.TS.XViD-IMAGiNE.6247693.TPB.torrent | 105   | 300     |
    And I stub IMDB to have the following movies
      | title              | year  |
      | The Fighter        | 2010  |
      | Battle Los Angeles | 2011  |
    When I source torrents
    Then I should have the follow movies
      | movie_name         | movie_year | swarm_score | current_rank |
      | The Fighter        | 2010       | 410         | 1            |
      | Battle Los Angeles | 2011       | 405         | 2            |
    And I should have the following torrent stats
      | torrent_name                                                | movie_name         | seeds | leaches | swarm_size |
      | The_Fighter[2010]DvDrip[Eng]-FXG.6210306.TPB.torrent        | The Fighter        | 100   | 250     | 350        |    
      | The_Fighter_(2010)_DVDRip_XviD-MAX.6209036.TPB.torrent      | The Fighter        | 10    | 50      | 60         |    
      | Battle.Los.Angeles.2011.TS.XViD-IMAGiNE.6247693.TPB.torrent | Battle Los Angeles | 105   | 300     | 405        |    
