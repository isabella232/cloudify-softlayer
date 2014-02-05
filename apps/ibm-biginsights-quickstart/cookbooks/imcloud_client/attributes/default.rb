default['imcloud_client']['return'] = ""

default[:imcloud][:api][:create_yaml] = "NO"

default[:imcloud][:api][:key]    = ""
default[:imcloud][:api][:url]    = "https://my.imdemocloud.com/api"

default[:cloud][:provider]       = nil

case node[:cloud][:provider]
 when "ec2"
    default[:imcloud_client][:cloud] = "aws"
 else
    default[:imcloud_client][:cloud] = nil
end
