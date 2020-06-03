case ENV['RAILS_ENV']
when 'production'
  $listen  = File.expand_path 'tmp/sockets/task/unicorn.sock', $app_dir
else
  $listen  = File.expand_path 'tmp/sockets/unicorn.sock', $app_dir
end

$worker  = 2
$timeout = 120
$app_dir = '/umbrellanotice'
$pid     = File.expand_path 'tmp/pids/unicorn.pid', $app_dir
$std_log = '/dev/stdout'

worker_processes  $worker
working_directory $app_dir
stderr_path $std_log
stdout_path $std_log
timeout $timeout
listen  $listen
pid $pid
logger Logger.new($stdout)

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      Process.kill "QUIT", File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
