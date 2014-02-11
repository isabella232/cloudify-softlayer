#
# Cookbook Name:: blustratus
# Recipe:: setup_bootstrap_site
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'ruby_build'

cookbook_file "rails_bootstrap.tar.gz" do
  path "/tmp/rails_bootstrap.tar.gz"
end

yum_package "wget"

bash "extract blu bootstrap website" do
  code <<-EOH
    mkdir -p /var/www/blu-bootstrap
    tar --index-file /tmp/bootstrap.tar.log -xvvf /tmp/rails_bootstrap.tar.gz -C /var/www/blu-bootstrap
  EOH
  action :run
end

template "/var/www/blu-bootstrap/config/bootstrap.yml"

cookbook_file '/var/www/blu-bootstrap/lib/cogstartup.xml.erb' do
  cookbook 'cognos_bi'
  manage_symlink_source true
end

file "Delete Rails bootstrap media" do
  backup false
  path "/tmp/rails_bootstrap.tar.gz"
  action :delete
end

ruby_build_ruby '1.9.3-p484' do
  prefix_path '/usr/local'
  action :install
end

imcloud_client node[:bootstrap][:redis] do
  api_key node[:imcloud][:api][:key]
  action :download
end

bash "extract #{node[:imcloud_client][:return]}" do
  code lazy { "mv #{node[:imcloud_client][:return]} /opt/" }
  action :run
end

bash "Install Redis" do
  code <<-EOH
    cd /opt

    tar xzf redis-*.tar.gz
    rm -f redis-*.tar.gz

    mv redis-* redis
    cd redis
    make

    ln -fs /opt/redis/src/redis-server /usr/local/bin
    ln -fs /opt/redis/src/redis-cli /usr/local/bin
  EOH
end

gem_package "bundler"
yum_package "sqlite-devel" do
  arch 'x86_64'
  action :install
end

bash "Install Bootstrap gems" do
  cwd "/var/www/blu-bootstrap"
  code 'bundle install'
end

template "/etc/init.d/rails" do
  owner "root"
  group "root"
  mode 0755
  variables({
    :cloud => node[:cloud][:provider].upcase
  })
end

bash "add rails to startup" do
  code <<-EOH
    chkconfig --add rails
    chkconfig rails on
  EOH
end
