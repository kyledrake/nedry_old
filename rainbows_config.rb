Rainbows! do
  use :ThreadPool
  client_max_body_size nil # This is set in nginx
  # keepalive_timeout 1
    worker_processes 4
    worker_connections 32
    timeout 30
end
