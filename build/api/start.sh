#! /bin/sh

set -e

bundle exec rake db:migrate  # Perform database migrations for the application

ruby app.rb -o "0.0.0.0" # This line starts the application