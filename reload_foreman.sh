#!/bin/bash
source ~/.bashrc  # Load user environment variables, including PATH
source ~/.profile # Ensure full environment is available

# Stop execution if any command fails
set -e

echo "🚀 Installing gems..."
bundle install

echo "🚀 Exporting translations..."
RAILS_ENV=development bundle exec i18n export

echo "📦 Running database migrations..."
RAILS_ENV=development bundle exec rake db:migrate

echo "🎨 Precompiling assets..."
RAILS_ENV=development bundle exec rake assets:precompile
