#
# Cookbook Name:: blustratus
# Recipe:: prepare_for_image
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#

bash "Remove all SSH keys and config" do
  code <<-EOH
    rm -rf /root/.ssh/*
    rm -rf /home/*/.ssh
  EOH
end

bash "Remove bash history" do
  code <<-EOH
    rm -rf /root/.bash_history
    rm -rf /home/*/.bash_history
  EOH
end

bash "Remove temporary files" do
  code <<-EOH
    rm -rf /tmp/*
  EOH
end

## LDAP-authenticating users
ldap_users = [
  'bluadmin',
  'bluuser',
  'user1'
]

ldap_users.each do |username|
  password = SecureRandom.urlsafe_base64 20*3/4
  bash "Update #{username} ldap password" do
    code <<-EOH
      ldappasswd -x -D "cn=bluldap,dc=blustratus,dc=com" \\
      -w #{node[:ldap][:password]} \\
      -S "uid=#{username},ou=People,dc=blustratus,dc=com" \\
      -s #{password}
    EOH
  end
end

## OS-authenticating users
os_users = [
  node[:db2][:instance][:username],
  node[:db2][:fenced][:username],
  node[:db2][:das][:username]
]

os_users.each do |username|
  password = SecureRandom.urlsafe_base64 20*3/4
  encrypted = password.crypt "$6$#{SecureRandom.urlsafe_base64 8*3/4}"
  bash "Update #{username} OS password" do
    code <<-EOH
      usermod -p "#{encrypted.gsub("$","\\$")}" #{username}
      usermod -L #{username}
    EOH
  end
end

template '/etc/init.d/blustratus' do
  owner 'root'
  group 'root'
  mode 0755
end

bash 'Remove Apache and OpenLDAP from startup' do
  code <<-EOH
    chkconfig --del httpd
    chkconfig --del slapd

    service blustratus stop
  EOH
end

# Remove Cognos startup config
file "#{node[:cognos][:install_path]}/configuration/cogstartup.xml" do
  backup false
  action :delete
end

bash 'Get rid of SWAP' do
  code <<-EOH
    swapoff #{node[:swap][:file]}
    rm -f #{node[:swap][:file]}
  EOH
end
