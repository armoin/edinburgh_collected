[![Code Climate](https://codeclimate.com/github/urfolomeus/edinburgh_stories.png)](https://codeclimate.com/github/urfolomeus/edinburgh_stories)
[![Test Coverage](https://codeclimate.com/github/urfolomeus/edinburgh_stories/badges/coverage.svg)](https://codeclimate.com/github/urfolomeus/edinburgh_stories)
[![Build Status](https://travis-ci.org/urfolomeus/edinburgh_stories.svg?branch=master)](https://travis-ci.org/urfolomeus/edinburgh_stories)
[![Dependency Status](https://gemnasium.com/urfolomeus/edinburgh_stories.svg)](https://gemnasium.com/urfolomeus/edinburgh_stories)


# Edinburgh Collected

This is the working title for a city-wide shared memory app developed for City of Edinburgh Council Libraries divsion as part of the Nesta programme.


# Running Edinburgh Collected

## Pre-requisities

* git
* ruby 2.1.2 (optional: rvm or rbenv)

## Installing

```bash
  git clone git@github.com:urfolomeus/edinburgh-stories.git
  cd edinburgh-stories
  bundle install
  rake db:migrate
```

## Running

* `rails s`
* Edinburgh Collected should now be available at [http://localhost:3000](http://localhost:3000).


## Forking the app


### Recreating the sensitive files

You will need to generate the following files and ensure that you don't commit them to the public repo (the .gitignore file for the project should do this automatically).

* `cp config/database.yml.example config/database.yml` then add your database names as appropriate.
* `cp config/application.yml.example config/application.yml` and complete as required.
* You'll need to make the necessary adjustments to `config/initializers/carrierwave.rb` in order to point to the places where you want to store the application's files.
