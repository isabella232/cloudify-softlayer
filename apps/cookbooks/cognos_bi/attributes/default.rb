# Inputs:
default[:cognos][:config_path]          = '/'
default[:cognos][:version]              = '10.2.1'
default[:cognos][:fixpack_versions]     = ['FP1', 'FP1 IF3']
default[:cognos][:install_fixpacks]     = 'NO'
default[:cognos][:install_sdk]          = 'YES'
default[:cognos][:cm][:directory]       = '/home/db2inst1'

default[:cognos][:install_path]         = ::File.join(default[:cognos][:config_path], 'opt/ibm/cognos')

default[:cognos][:caf][:enabled]        = 'false'
default[:cognos][:report_server][:arch] = '64'
default[:cognos][:java_home]            = '/opt/ibm/java-x86_64-70/jre'

# INPUTS FOR IMCLOUD_CLIENT
default[:imcloud][:download_directory]  = '/mnt/blumeta0/downloads'

# INPUTS FOR DB2
default[:cognos][:ip]                   = node[:fqdn]
