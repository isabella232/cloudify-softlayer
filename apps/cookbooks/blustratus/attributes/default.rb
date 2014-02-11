default[:console][:download_name]       = 'BLU Stratus Web Console'
default[:console][:install][:path]      = "/opt/ibm/dsserver"
default[:console][:config_prefix]       = "/opt/ibm/dsserver"
default[:console][:config_path]         = ::File.join(node[:console][:config_prefix], "/ldap/Config")
default[:console][:metadb][:directory]  = "/home/db2inst1"
default[:console][:ip]                  = node[:fqdn]
default[:console][:port]                = '8443'

default[:console][:dbDIR]               = ::File.join(node[:console][:install][:path], "/ldap/Config")

default[:ldap][:ip]                     = node[:fqdn]
default[:ldap][:port]                   = "389"
default[:ldap][:password]               = "passw0rd"
default[:ldap][:admin]                  = "bluldap"
default[:ldap][:home_directory]         = "/home"

#node.default['LDAP_ENCRYPTED_PASSWORD']="#{node[:console][:install][:path]}"/dsutil/bin/crypt.sh node.default['LDAP_PASSWORD']
default[:ldap][:encrypted_password]     = ""
default[:ldap][:first]                  = "YES"
default[:ldap][:slapd_location]         = "/usr/local/lib/slapd"

default[:callback][:params][:id]        = ""
default[:callback][:hostname]           = "beta.imdemocloud.com"
default[:callback][:port]               = "443"
default[:callback][:protocol]           = (default[:callback][:port] == "80") ? "http" : "https"
default[:callback][:run]                = "YES"

#  {
#    ip_address: "",
#    username:   "",
#    password:   "",
#    format:     "YES",
#    mount_dir:  "/mnt/iscsi1"
#  }
default[:iscsi]                         = []

memory, type = node['memory']['total'].scan(/(\d+)(\w+)/)[0]

default[:swap][:type]                   = type
default[:swap][:memory]                 = ((memory.to_i*0.25).round).to_s
default[:swap][:file]                   = "/mnt/swap"

default[:bootstrap][:ready_file]        = '/var/www/ready'
default[:bootstrap][:redis]             = 'Redis 2.6.16'
