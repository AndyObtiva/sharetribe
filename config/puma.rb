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
  workers 4
end
if ENV['PUMA_PRELOAD_APP'].to_s.downcase == 'true'
  preload_app!
end
