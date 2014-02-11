#
# Cookbook Name:: db2
# Recipe:: dsdriver
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when "debian", "ubuntu"
  log "Debian/Ubuntu not supported"
  exit 1
else
  yum_package "compat-libstdc++-33.i386"
end

directory node[:db2][:dsdriver][:install_path] do
  action :create
  recursive true
  not_if { ::File.exists?(node[:db2][:dsdriver][:install_path]) } 
end


#product="${DSDRIVER_INSTALL_MEDIA} (${arch})"
imcloud_client node[:db2][:dsdriver][:download_name] do
  api_key node[:imcloud][:api][:key]
  action :download
end

odbc_cli_tarfile="#{node[:db2][:dsdriver][:install_path]}/dsdriver/odbc_cli_driver/#{node[:db2][:dsdriver][:arch]}/ibm_data_server_driver_for_odbc_cli*.tar.gz"

bash "extract-dsdriver-1" do
  code lazy { "tar --index-file /tmp/dsdriver1.tar.log -xvvf #{node[:imcloud_client][:return]} -C #{node[:db2][:dsdriver][:install_path]}" }
  action :run
end

bash "extract-dsdriver-2" do
  code "tar --index-file /tmp/dsdriver2.tar.log -xvvf #{odbc_cli_tarfile} -C #{node[:db2][:dsdriver][:install_path]}"
  action :run
end

bash "install-dsdriver" do
  code "cp -ru #{node[:db2][:dsdriver][:install_path]}/clidriver/* /usr"
  action :run
end

file "Delete db2 media" do
  backup false
  path lazy { node[:imcloud_client][:return] }
  action :delete
end
