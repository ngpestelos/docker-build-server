server: bundle exec puma -e $RACK_ENV -p $PORT -C config/puma.rb
worker: builder -work -namespace=$REDIS_NAMESPACE -queues=$DOCKER_BUILD_QUEUE -uri=$REDIS_URL
