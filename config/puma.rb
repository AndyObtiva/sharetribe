if ENV['RAILS_ENV'] == 'production'
  plugin "heroku"
  on_worker_boot do
   ActiveSupport.on_load(:active_record) do
     ActiveRecord::Base.establish_connection
   end
  end
  before_fork do
   ActiveRecord::Base.connection_pool.disconnect!
  end
else
  threads 4,4
  workers 4
end
if ENV['PUMA_PRELOAD_APP'].to_s.downcase == 'true'
  preload_app!
end
