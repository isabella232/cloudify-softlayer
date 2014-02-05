#
# Cookbook Name:: imcloudapi
# Recipe:: default
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
  %w{httpd libstdc++-devel mod_ssl}.each do |pkg|
    package pkg
  end

  %w{libstdc++ libX11}.each do |pkg|
    yum_package pkg do
	  arch "i686"
	  action :install
    end
  end
end

