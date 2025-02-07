#!/bin/bash

# Stop execution if any command fails
set -e

echo "🚀 Exporting translations..."
RAILS_ENV=development bundle exec i18n export

echo "📦 Running database migrations..."
RAILS_ENV=development bundle exec rake db:migrate

echo "🎨 Precompiling assets..."
RAILS_ENV=development bundle exec rake assets:precompile

echo "🔥 Shuting down running Foreman..."
./killport 3019

echo "🔥 Starting Foreman..."
foreman start --env development.env
