#!/usr/bin/env bash
set -e
if [ "$1" = 'puma' ]
then  
  wait-for-it $DB_HOST:5432 -s -t 30 -- bundle exec rails db:prepare
  trap 'pkill -TERM -f puma' SIGTERM
  exec tail -f /dev/null &
  bundle exec puma
  wait
elif [ "$1" = 'development' ]
then
  rm -rf tmp/pids/server.pid
  bundle install
  wait-for-it $DB_HOST:5432 -s -t 30 -- bundle exec rails db:prepare
  bundle exec rails s -b 0.0.0.0
elif [ "$1" = 'test' ]
then
  bundle install
  wait-for-it $DB_HOST:5432 -s -t 30 -- bundle exec rails db:prepare
  bundle exec rails test
elif [ "$1" = 'rails' ]
then
  bundle install
  bundle exec "$@"
elif [ "$1" = 'bundle' ]
then
  bundle install
  "$@"
else
  exec "$@"
fi