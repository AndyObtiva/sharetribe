if ['production', 'staging'].include?(ENV['RAILS_ENV'].to_s.downcase)
  plugin "heroku"
  on_worker_boot do
   ActiveSupport.on_load(:active_record) do
     ActiveRecord::Base.establish_connection
   end
  end
  before_fork do
   ActiveRecord::Base.connection_pool.disconnect!
  end
  threads (ENV['PUMA_THREADS_MIN'] || 1).to_i,(ENV['PUMA_THREADS_MAX'] || 1).to_i
  workers (ENV['PUMA_WORKERS'] || 1).to_i
else
  threads 1,1
  workers 1
  # TODO make code conditional and config-dependent to handle case when key is not available and variables
  bind 'tcp://anapog.lvh.me:3000'
  #ssl_bind 'anapog.lvh.me', '3000', {
  #  key: '/Users/User/.ssh/server.key',
  #  cert: '/Users/User/.ssh/server.crt'
  #}
end
if ENV['PUMA_PRELOAD_APP'].to_s.downcase == 'true'
  preload_app!
end
