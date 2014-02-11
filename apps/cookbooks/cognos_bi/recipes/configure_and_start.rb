#
# Cookbook Name:: cognos_bi
# Recipe:: configure_and_start
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#

yum_package "libX11" do
  arch "x86_64"
  action :install
end

if node[:fqdn] == node[:db2][:ip]
  bash "Move db2 jar files" do
    code <<-EOH
      if [ -f "#{node[:db2][:install_path]}/java/db2jcc.jar" ]; then
        mv #{node[:db2][:install_path]}/java/db2jcc*.jar #{node[:cognos][:install_path]}/webapps/p2pd/WEB-INF/lib/
      fi
    EOH
    action :run
  end
else
  log "Remote DB2 not enabled yet"
  bash "Move db2 jar files" do
    code <<-EOH
      scp root@#{node[:db2][:ip]}:#{node[:db2][:install_path]}/java/db2jcc*.jar #{node[:cognos][:install_path]}/webapps/p2pd/WEB-INF/lib/
    EOH
    action :run
  end
end

template ::File.join(node[:cognos][:install_path], 'configuration/cogstartup.xml')
template ::File.join(node[:cognos][:install_path], 'bin64/startup.sh')

#remote_file "/opt/ibm/java-x86_64-70/jre/lib/ext/bcprov-jdk14-145.jar" do
#  source "file://#{node[:cognos][:install_path]}/bin64/jre/7.0/lib/ext/bcprov-jdk14-145.jar"
#end

bash "Move bcprov jar" do
  code <<-EOH
    if [ -f "#{node[:cognos][:install_path]}/bin64/jre/7.0/lib/ext/bcprov-jdk14-145.jar" ]; then
      mv #{node[:cognos][:install_path]}/bin64/jre/7.0/lib/ext/bcprov-jdk14-145.jar /opt/ibm/java-x86_64-70/jre/lib/ext/bcprov-jdk14-145.jar
  	fi
  EOH
  action :run
end

#echo "export JAVA_HOME=/opt/ibm/java-x86_64-70/jre" >> ~/.bashrc
#echo "export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${DB2_INSTALL_PATH}/lib64:${DB2_INSTALL_PATH}/lib32:${COGNOS_INSTALL_PATH}/cgi-bin" \
#  >> ~/.bashrc
#
#source ~/.bashrc
#
#echo "export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${DB2_INSTALL_PATH}/lib64:${DB2_INSTALL_PATH}/lib32:${COGNOS_INSTALL_PATH}/cgi-bin" \
#  >> /etc/sysconfig/httpd
bash "Setup Cognos exports" do
  code <<-EOH
    echo "export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:#{node[:db2][:install_path]}/lib64:#{node[:db2][:install_path]}/lib32:#{node[:cognos][:install_path]}/cgi-bin" >> ~/.bashrc
  	echo "export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:#{node[:db2][:install_path]}/lib64:#{node[:db2][:install_path]}/lib32:#{node[:cognos][:install_path]}/cgi-bin" >> /etc/sysconfig/httpd
  EOH
  action :run
end


cookbook_file '/etc/httpd/conf.d/cognos.conf'

service "httpd" do
  action :restart
end

#ServiceWaitInterval=number of milliseconds 
#ServiceMaxTries=number of times 
bash "Update Cognos BI Timeouts" do
  code <<-EOH
    echo "ServiceWaitInterval=5000" >> #{node[:cognos][:install_path]}/configuration/cogconfig.prefs
	echo "ServiceMaxTries=1500" >> #{node[:cognos][:install_path]}/configuration/cogconfig.prefs
  EOH
  action :run
end


bash "Save config and restart Cognos BI" do
  code "#{node[:cognos][:install_path]}/bin64/cogconfig.sh -s"
  environment 'JAVA_HOME' => node[:cognos][:java_home]
  returns [0,2]
  action :run
end

cognossdk_path = "/tmp/cognossdk"

directory cognossdk_path do
  recursive true
end

cookbook_file "#{cognossdk_path}/CognosAdminServices.java"
cookbook_file "#{cognossdk_path}/configCognos.sh" do
  mode 00755
end

# configCognos.sh \
#   <cognos_install_dir> \
#   <JAVA_HOME> \
#   <HOSTNAME> \
#   <PORT> \
#   <bluadmin> \
#   <bluadmin_passwd> \
#   <MIN HEAP> \
#   <MAX HEAP>
## TODO: Calculate min_heap and max_heap properly
min_heap = '4915'
max_heap = '4915'
bash "Configure Cognos via SDK" do
  code <<-EOH
    cd #{cognossdk_path}
    ./configCognos.sh \
      #{node[:cognos][:install_path]} \
      #{node[:cognos][:ip]} \
      9300 \
      bluadmin \
      #{node[:ldap][:password]} \
      #{min_heap} \
      #{max_heap}
  EOH
  environment 'JAVA_HOME' => node[:cognos][:java_home]
end

directory cognossdk_path do
  action :delete
  recursive true
end


bash "Save config and restart Cognos BI" do
  code "#{node[:cognos][:install_path]}/bin64/cogconfig.sh -s"
  environment 'JAVA_HOME' => node[:cognos][:java_home]
  action :run
end
