web:         bundle exec puma -C config/puma.rb # -b tcp://$HOST:$PORT -p $PORT --max-pool-size $PASSENGER_MAX_POOL_SIZE
worker:      QUEUES=default,paperclip,mailers bundle exec rake jobs:work
#web1:         bundle exec passenger start -p $PORT --max-pool-size $PASSENGER_MAX_POOL_SIZE
