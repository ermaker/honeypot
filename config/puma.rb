workers Integer(ENV['WEB_CONCURRENCY']) if ENV.key?('WEB_CONCURRENCY')
if ENV.key?('MAX_THREADS')
  threads_count = Integer(ENV['MAX_THREADS'])
  threads threads_count, threads_count
end

port ENV['PORT']
environment ENV['RAILS_ENV']

preload_app!

on_worker_boot do
end
