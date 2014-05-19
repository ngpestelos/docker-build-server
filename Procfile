server: bundle exec puma -e $RACK_ENV -p $PORT -C config/puma.rb
worker: docker-build-worker -namespace=$REDIS_NAMESPACE -queues=$DOCKER_BUILD_QUEUE -t=$GITHUB_API_TOKEN -uri=$REDIS_URL
