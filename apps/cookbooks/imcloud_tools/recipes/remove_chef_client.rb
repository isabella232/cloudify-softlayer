#
# Cookbook Name:: imcloud_tools
# Recipe:: remove_chef_client
#
# Copyright 2014, IBM
#
# All rights reserved - Do Not Redistribute
#

bash 'Remove all Chef client files' do
  code <<-EOH
    rm -rf \
      /etc/chef \
      /var/chef \
      /opt/chef \
      /usr/bin/chef-apply \
      /usr/bin/chef-solo \
      /usr/bin/chef-shell \
      /usr/bin/chef-client
  EOH
end
