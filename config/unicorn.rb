# config/unicorn.rb
if ENV["RAILS_ENV"] == "production"
  worker_processes 1
else
  worker_processes 3
end

listen 3000
timeout 30

preload_app true

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end