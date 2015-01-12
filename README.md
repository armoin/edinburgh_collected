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
