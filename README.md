# reddit-saves

## Dependencies

Make sure to install all the necessary gems via `bundle install`

## Setup

Create a `.env` file in the following format:

```
USERNAME=xxxxx
PASSWORD=xxxxx
DATABASE="postgres://USERNAME@localhost/reddit-saves-test"
```

Note: You may need to escape special characters in your password, like: `\$`

Create and setup the database:

```
$ createdb reddit-saves-test
$ bundle exec rake db:setup
```

Create a CSV of all currently saved items on Reddit:

```
$ ./collect_saved_items.rb
```

Import data from the CSV to the database:

```
$ bundle exec rake db:import
```
