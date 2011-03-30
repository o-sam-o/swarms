# Swarms

Overview
--------
Swarms is a movie/torrent discovery website.  The site uses the innately social nature of BitTorrent to sort movies by popularity which makes it easy to discover new films or rips.  The site tracks and records swarm sizes in order to provide historic insight about the popularity of movies.

Project Status
--------------
Creating a BitTorrent site is a fool's errand, their legality is questionable and the only practical income source is banner advertising.  That said I have always wanted to make a BitTorrent site.
I always felt there was something lacking, in the standard run of the mill boring table oriented torrent sites.  Somehow I started building Swarms in-between projects and then where do you stop?  
I don't really want to deal with the legal issues or the promotional activities required to build a popular torrent site.  Therefore I have decided to have my own private installation of Swarms and put the
source up on github!


Features
--------
 * Scraps The [Pirate Bay](http://thepiratebay.org/) to discover new movies and detect swarm sizes
 * Automatic conversion of torrent name to movie titles (Uses [toname](http://github.com/o-sam-o/toname)) 
 * Admin screens for manually correcting torrent to movie name mappings
 * Scraps movie metadata from IMDB (Uses [Yayimdbs](http://github.com/o-sam-o/yayimdbs))
 * Embedded movie trailer (Youtube)
 * Records and graphs movie swarm sizes
 * Customisable links for downloading movies
 * iPad swipe pagination on home page

Screenshots
-----------

![Home Page](http://farm5.static.flickr.com/4022/5163897480_799a73de3b_z.jpg) 

Home Page

![View Video](http://farm5.static.flickr.com/4038/5163897550_5e4670b718_z.jpg)

View Movie Details

![Watch Trailer](http://farm5.static.flickr.com/4027/5163290689_605128edd1_z.jpg)

Watch a Movie Trailer

Installation
------------
_This guide has been developed against Ubuntu 10.04_

__Step 1: Server prerequisite__

install mysql:

    sudo apt-get install mysql-server mysql-client libmysqlclient-dev

install other stuff:

    sudo apt-get install curl vim git-core libxml2-dev libxslt-dev

install rvm: http://rvm.beginrescueend.com/rvm/install/

rvm setup:

    rvm package install zlib
    rvm install 1.9.2
    rvm 1.9.2
    rvm gemset create sw
    rvm 1.9.2@sw

__Step 2: Download app__

    sudo mkdir /var/www
    cd /var/www
    sudo git clone git://github.com/o-sam-o/swarms.git
    cd swarms

__Step 3: Install required gems__
    
    gem install bundler
    sudo mkdir .bundle
    sudo chmod 777 .bundle/
    bundle install --without development test 

__Step 4: Setup database__

     mysqladmin -u root -p create swarms
     
     mysql -u root -p
     grant usage on *.* to swarms@localhost identified by 'password_here';
     grant all privileges on swarms.* to swarms@localhost;
     exit

Now update the password in /var/www/swarms/config/database.yml to your password

__Step 5: Migrate database__

    sudo mkdir log
    sudo touch log/production.log
    sudo chmod 0666 log/production.log
    sudo chmod 0666 db/schema.rb

    rake db:migrate RAILS_ENV=production

__Step 6: Set directory permissions__

The app will download images and add them to the public folder

    sudo chmod -R 777 public/

__Step 7: Scrap torrent info__

Scrap for new torrent info

    rake source_torrents RAILS_ENV=production

Compile statics based on recent torrent scrapings

    rake add_movie_stats RAILS_ENV=production

Both of these rake tasks are intended to be regularly kicked off by cron

__Stap 8: Start the web server__

Install and start Passenger: [http://www.modrails.com/install.html](http://www.modrails.com/install.html)

Licence
-------
MIT (excluding all the stuff copied from others, e.g. theme)

Contact
-------
Sam Cavenagh [(cavenaghweb@hotmail.com)](mailto:cavenaghweb@hotmail.com)
