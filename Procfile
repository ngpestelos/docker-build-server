server: bundle exec unicorn -c .unicorn.conf -p $PORT -E $RACK_ENV
worker: docker-build-worker -namespace=$REDIS_NAMESPACE -queues=$DOCKER_BUILD_QUEUE -t=$GITHUB_API_TOKEN -uri=$REDIS_URL
