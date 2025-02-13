#!/bin/bash

# Stop execution if any command fails
set -e

echo "🚀 Exporting translations..."
~/.rbenv/shims/bundle exec i18n export

echo "📦 Running database migrations..."
~/.rbenv/shims/bundle exec rake db:migrate

echo "🎨 Precompiling assets..."
~/.rbenv/shims/bundle exec rake assets:precompile
