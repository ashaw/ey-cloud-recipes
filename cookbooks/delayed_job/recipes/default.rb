#
# Cookbook Name:: delayed_job
# Recipe:: default
#

#https://gist.github.com/272257/637c9252b137dee44da8c365d640d5c53f194217

if ['solo', 'app', 'app_master'].include?(node[:instance_role])

  # be sure to replace "app_name" with the name of your application.
  run_for_app("polltracker_production") do |app_name, data|
  
    worker_name = "delayed_job"
    
    # The symlink is created in /data/app_name/current/tmp/pids -> /data/app_name/shared/pids, but shared/pids doesn't seem to be?
    directory "/data/#{app_name}/shared/pids" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0755
    end

    template "/etc/monit.d/delayed_job_worker.#{app_name}.monitrc" do
      source "delayed_job_worker.monitrc.erb"
      #owner node[:owner_name]
      #group node[:owner_name]
      owner "root"
      group "root"
      mode 0644
      variables({
        :app_name => app_name,
        :user => node[:owner_name],
        :worker_name => worker_name,
        :framework_env => node[:environment][:framework_env]
      })
    end
    
    bash "monit-reload-restart" do
       user "root"
       code "monit reload && monit"
    end
      
  end
  

end
