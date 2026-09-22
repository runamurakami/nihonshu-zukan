set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
DATABASE_URL="$DATABASE_URL_DIRECT" bundle exec rails db:migrate
bundle exec rails db:seed
