server: bundle exec puma -e $RAILS_ENV -p 5000 -C config/puma.rb
worker: builder -work -namespace=$REDIS_NAMESPACE -queues=$DOCKER_BUILD_QUEUE -uri=$REDIS_URL
