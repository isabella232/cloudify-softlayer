#
# Cookbook Name:: blustratus
# Recipe:: configure_os
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#

bash "Update ulimit for all users" do
  code <<-EOH
    echo "* soft nofile 65535" >> /etc/security/limits.conf
    echo "* hard nofile 65535" >> /etc/security/limits.conf
    echo "* soft sigpending 1032252" >> /etc/security/limits.conf
    echo "* hard sigpending 1032252" >> /etc/security/limits.conf
    echo "* soft memlock unlimited" >> /etc/security/limits.conf
    echo "* hard memlock unlimited" >> /etc/security/limits.conf
    echo "* soft stack unlimited" >> /etc/security/limits.conf
    echo "* hard stack unlimited" >> /etc/security/limits.conf
    echo "* soft nproc unlimited" >> /etc/security/limits.conf
    echo "* hard nproc unlimited" >> /etc/security/limits.conf

    echo "ulimit -n 65535" >> /etc/bashrc
    echo "ulimit -i 1032252" >> /etc/bashrc
    echo "ulimit -l unlimited" >> /etc/bashrc
    echo "ulimit -s unlimited" >> /etc/bashrc
    echo "ulimit -u unlimited" >> /etc/bashrc
  EOH
end

bash "Disable selinux" do
  code <<-EOH
    echo 0 > /selinux/enforce
    sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
  EOH
end

#bash "Disable requiretty in sudoers" do
#  code <<-EOH
#    sed -i 's/Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers
#  EOH
#end


disk = node[:filesystem].detect { |k, v| v["mount"] == "/" }.first

bash "Resize root volume" do
  code <<-EOH
    resize2fs #{disk}
  EOH
end

bash "Disable iptables" do
  code <<-EOH
    service iptables stop
	chkconfig iptables off
  EOH
end
