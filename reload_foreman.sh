#!/bin/bash

# Stop execution if any command fails
set -e

echo "🚀 Exporting translations..."
RAILS_ENV=development ~/.rbenv/shims/bundle exec i18n export

echo "📦 Running database migrations..."
RAILS_ENV=development ~/.rbenv/shims/bundle exec rake db:migrate

echo "🎨 Precompiling assets..."
RAILS_ENV=development ~/.rbenv/shims/bundle exec rake assets:precompile
