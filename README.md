Development environment setup
=============================

On OS X:

1. Install [Homebrew](https://brew.sh)
1. `brew install git`
1. Install Ruby 2.4.1 ([rbenv](https://github.com/rbenv/rbenv#installation) recommended)
1. `brew install postgres`
1. `initdb /usr/local/var/postgres -E utf8`
1. Clone this Git repository
1. `cd activities`
1. `gem install bundler`
1. `bundle install`
1. `gem install foreman`
1. `foreman start postgres_dev &` (starts postgres in the background temporarily to run rake db:setup)
1. `foreman run bundle exec rake db:setup`
1. `foreman start`
1. [http://localhost:5000/](http://localhost:5000/)

Running tests
=============

1. `bundle exec rake spec`

Running the example
===================

1. `./bin/send_activity_data.sh`

Design Notes
============

Two main entities:

 * ActivityDatum: Represents data sent by a driver's mobile device
 * ActivityReport: Represents aggregate ActivityData, presentable in report form

Two main API endpoints:

 * POST activity_data/create - accepts an ActivityDatum from a driver's mobile device
 * GET activity_reports/:company_id/:driver_id - returns a JSON report of the driver's activities

Incomplete: Geolocation lookup for field/road location was not finished. I ran
into issues getting PostGIS working, and I've run out of time. I've done this
before though, and here's the solution I wanted to implement:

 * As each ActivityDatum enters the system, a module would assign it a particular
   location_type (field or road), based on its location and the company's shape data
 * Shape data could be inserted into the system via an API point
 * The calculation would be done using PostGIS and it's spatial functions

Future Work
===========

 * Permit POSTing multiple ActivityData at the same time. It seems reasonable to
   me that data from driver's mobiles will come in bursts at times, and it makes
   sense to not require each datum to require one API call
 * Authentication

Scalability
===========

This was designed in a very modular manner, such that some aspects could be
broken out into their own service and independently scaled. For example,
LocationLookup could be its own service that saves the location type on an
ActivityDatum whenever such a record is created. The DataManager, which handles
combining ActivityData into ActivityReports could also be split out into its
own microservice, which would perform its work after the LocationLookup service
is finished with a given ActivityDatum.

For dealing with huge field geometries, a spatial index in PostGIS is a must.
Otherwise, a sharded PostGIS instance could be developed, where each shard is
a subset (bounding box) of some of the fields (imagine a giant field subdivided
into X districts, where X is the number of shards).
