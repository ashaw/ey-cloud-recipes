#
# Cookbook Name:: generate_widget
# Recipe:: default
#

if ['solo', 'app', 'app_master'].include?(node[:instance_role])

	env = node[:environment][:framework_env]

  # be sure to replace "app_name" with the name of your application.
  run_for_app("polltracker") do |app_name, data| 
    
    bash "generate_widget" do
       user "deploy"
       code "cd /data/#{app_name}/current && rake polltracker:widget RAILS_ENV=#{env} && rake polltracker:sitemap RAILS_ENV=#{env}"
    end
      
  end
  

end