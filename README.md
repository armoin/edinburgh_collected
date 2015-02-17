[![Code Climate](https://codeclimate.com/github/urfolomeus/edinburgh_collected.png)](https://codeclimate.com/github/urfolomeus/edinburgh_collected)
[![Test Coverage](https://codeclimate.com/github/urfolomeus/edinburgh_collected/badges/coverage.svg)](https://codeclimate.com/github/urfolomeus/edinburgh_collected)
[![Build Status](https://travis-ci.org/urfolomeus/edinburgh_collected.svg?branch=master)](https://travis-ci.org/urfolomeus/edinburgh_collected)
[![Dependency Status](https://gemnasium.com/urfolomeus/edinburgh_collected.svg)](https://gemnasium.com/urfolomeus/edinburgh_collected)


# Edinburgh Collected

This is a city-wide shared memory app developed for City of Edinburgh Council Libraries divsion as part of the Nesta programme.


# Running Edinburgh Collected

## Prerequisities

### Ruby

We are currently using **2.1.5**. If you don't want to upgrade your whole system to this version you can install RVM (Ruby Version Manager). This makes it easy to install and run different Ruby versions.

```bash
# install rvm and correct version of ruby
sudo curl -L https://get.rvm.io | bash -s stable --ruby=2.1.5

# start rvm in any open shells (will happen automatically in any new shells from now on)
sudo source /home/edincollect/.rvm/scripts/rvm

# [OPTIONAL] set the installed version to be the system default
rvm use 2.1.5 --default
```

### ImageMagick

ImageMagick is required for manipulating images. You can install it using your operating system's package manager. For example:

```
# using homebrew
brew install imagemagick
```

### Postgres

We currently use Postgres as our database so that we can use the Full Text Search functionality. It should be relatively easy to refactor to use a separate FTS engine instead and then your choice of database is more open.

Installing Postgres on your operating system is beyond the scope of this README, but if you can probably get most of the way [here](http://www.postgresql.org/download/).



## Installing

```bash
# clone the app (you might want to fork it to your own repo first if you're planning to make any changes)
git clone git@github.com:urfolomeus/edinburgh_collected.git
cd edinburgh_collected

# install the required gems
bundle install
```



## Post Installation


### Setting up environment-specific variables

The app uses certain environment-specific variables to control things such as file uploads and 3rd party services.
In order to ensure that you have these setup as required, please do as follows:

```bash
# (from the root directory of the project) copy the example application environment variable file
cp config/application.yml.example config/application.yml

# now open in your editor of choice and add the required information
vi config/application.yml
```


### Setting up the database(s)

Once you've setup the environment variables file, you can setup the database.

```bash
# setup the database
rake db:setup
```


### A note about moderation

The app is currently set up so that any new memory that is created must be moderated before it can be seen by anyone other than the user that created it or admin users. In order to moderate you need to have an admin account.

To create an admin user:

```bash
# Open config/application.yml in your favourite editor.
# Uncomment and set CREATE_DEFAULT_ADMIN_USER to 'true'
# Uncomment and set DEFAULT_ADMIN_USER_PASSWORD to a valid password
vi config/application.yml
```

Now run the seeds as mentioned below.


### Add required seed data to the database

Some data, such as city areas and memory categories, must be pre-poulated in the database. This can be done by running the following command.

```bash
# pre-populate the database with seed data
rake db:seed
```

### Changing the application to run in a different location

Whilst this application is called Edinburgh Collected, it should be possible to run it as <YOUR CITY> Collected. You can change the majority of the application by altering the details in `config/initializers/app_settings.rb`. If you have any questions or issues around this, please raise an issue on this main repository.


### Mailcatcher

The app is setup to use [Mailcatcher](http://mailcatcher.me) in development so that you can catch and check the emails generated if you wish. To setup mailcatcher, please do as follows:

```bash
# install the gem
gem install mailcatcher

# run mailcatcher (runs as a daemon in the background)
mailcatcher

# view Mailcatcher inbox
open http://localhost:1080
```


## Running

That should be the app all up and running for you now. You can check this by running the test suite `bundle exec rspec` or by starting up the server `rails s` and pointing your favourite browser to [http://localhost:3000](http://localhost:3000).

