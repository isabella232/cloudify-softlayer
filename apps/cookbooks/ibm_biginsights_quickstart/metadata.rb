name             'ibm_biginsights_quickstart'
maintainer       'IBM'
maintainer_email 'imcloud@ca.ibm.com'
license          'All rights reserved'
description      'Installs/Configures IBM BigInsights Quickstart'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'imcloud_client'

# My recipes
recipe "ibm_biginsights_quickstart::default",  "Install BigInsights Quickstart"


#
# My Attributes
#


### INPUTS FOR BIG INSIGHTS

attribute "biginsights/console/use_ssl",
   :display_name => "Use SSL?",
   :description => "Should https be configured for the web console?.",
   :required => "recommended",
   :default => "YES",
   :choice => ["YES","NO"],
   :recipes => ["ibm_biginsights_quickstart::default"]
    
attribute "biginsights/biadmin/password",
   :display_name => "Big Insights password",
   :description => "Password for the Big Insights admin.",
   :required => "recommended",
   :default => "passw0rd",
   :recipes => ["ibm_biginsights_quickstart::default"]
     
attribute "biginsights/master_hostname",
   :display_name => "Big Insights master hostname",
   :description => "Hostname for the Big Insights master node.",
   :required => "recommended",
   :default => "localhost",
   :recipes => ["ibm_biginsights_quickstart::default"]     
     
attribute "biginsights/bi_directory_prefix",
   :display_name => "Big Insights directory prefix",
   :description => "Directory prefix for Big Insights installation location.",
   :required => "recommended",
   :default => "/",
   :recipes => ["ibm_biginsights_quickstart::default"]    
     
attribute "biginsights/hadoop_distribution",
   :display_name => "Big Insights Hadoop distribution",
   :description => "Hadoop distribution name for Big Insights.",
   :required => "recommended",
   :default => "Apache",
   :recipes => ["ibm_biginsights_quickstart::default"]    
     
attribute "biginsights/data_node_unique_hostnames",
   :display_name => "Big Insights data node hostnames",
   :description => "Hostnames for the Big Insights data nodes.",
   :required => "recommended",
   :type => "array",
   :default => ["localhost"],
   :recipes => ["ibm_biginsights_quickstart::default"]                

