name             'imcloudapi'
maintainer       'IBM'
maintainer_email 'imcloud@ca.ibm.com'
license          'All rights reserved'
description      'Installs/Configures IMCloudAPI'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'imcloud_client'
depends 'imcloud_tools'
depends 'dc_logger'
depends 'db2'

supports "redhat"
