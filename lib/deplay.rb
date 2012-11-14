Capistrano::Configuration.instance.load do
  namespace :deplay do

   set :app_name, 'my_app'
   set :log_path, '/var/log'
   set :prod_conf, 'prod.conf' 
   set :deploy_to, '/var/lib/my_app'
   set :project_home, '.'

   task :setup do
      run "mkdir -p #{deploy_to}"
      put "#!/bin/bash\nnohup bash -c \"cd #{deploy_to} && target/start $* &>> #{log_path}/#{app_name}.log 2>&1\" &> /dev/null &", "#{deploy_to}/start.sh", :mode => '755', :via => :scp
      put "#!/bin/bash\npid=`cat RUNNING_PID 2> /dev/null`\nif [ \"$pid\" == \"\" ]; then echo '#{app_name} is not running'; exit 0; fi\necho 'Stopping #{app_name}...'\nkill -SIGTERM $pid", "#{deploy_to}/stop.sh", :mode => '755', :via => :scp
   end

   task :deploy_prod, :roles => :prod do
     package
     stop
     copy_app_files
     start_prod
   end

   task :deploy_dev, :roles => :dev do
     package
     stop
     copy_app_files
     start_dev
   end

   task :stop do
     depend :remote, deploy_to
     targets = find_servers_for_task(current_task)
     failed_targets = targets.map do |target|
       cmd = "ssh #{user}@#{target.host} 'cd #{deploy_to} && ./stop.sh'"
       target.host unless system cmd
     end.compact
     raise "Stopping #{app_name} failed on #{failed_targets.join(',')}" if failed_targets.any?
   end

   task :start_prod do
     targets = find_servers_for_task(current_task)
     failed_targets = targets.map do |target|
       cmd = "ssh #{user}@#{target.host} 'cd #{deploy_to} && ./start.sh -Dconfig.resource=#{prod_conf}'"
       target.host unless system cmd
     end.compact
     raise "Starting #{app_name} failed on #{failed_targets.join(',')}" if failed_targets.any?
   end

   task :start_dev do
     targets = find_servers_for_task(current_task)
     failed_targets = targets.map do |target|
       cmd = "ssh #{user}@#{target.host} 'cd #{deploy_to} && ./start.sh'"
       target.host unless system cmd
     end.compact
     raise "Starting #{app_name} failed on #{failed_targets.join(',')}" if failed_targets.any?
   end

   task :package do
     system "cd #{project_home} && play clean compile test stage"
     raise "Error in package task" if not $?.success?
   end

   task :copy_app_files do
     upload "#{project_home}/target", deploy_to, :via => :scp, :recursive => true
   end
  end
end
