default[:biginsights][:console][:use_ssl] = "YES"
default[:biginsights][:console][:port] = (node[:biginsights][:console][:use_ssl] == "YES") ? "9443" : "8080"

default[:biginsights][:biadmin][:password]  = "passw0rd"
default[:biginsights][:master_hostname]     = "localhost"
default[:biginsights][:bi_directory_prefix] = "/"
default[:biginsights][:hadoop_distribution] = "Apache"

case node[:cloud][:provider]
  when "ec2"
    default[:biginsights][:hostname] = node[:cloud][:public_hostname]
  when "softlayer"
    default[:biginsights][:hostname] = node[:cloud][:public_ipv4]
  else 
    default[:biginsights][:hostname] = node[:ipaddress]
end
