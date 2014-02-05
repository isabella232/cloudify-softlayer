name 'blustratus_totest'
description 'BluStratus single-node to build'
run_list  'recipe[blustratus::create_and_activate_swap]',
          'recipe[blustratus::setup_ibm_java_7_jdk]',
          'role[db2]',
          'role[cognos_bi]',
          'recipe[blustratus::setup_web_console]',
          'recipe[ldap]',
          'recipe[blustratus::setup_ldap]',
          'recipe[blustratus::configure_db2]',
          'recipe[cognos_bi::configure_db2_content_store]',
          'recipe[cognos_bi::setup_env_for_cognos_samples]',
          'recipe[cognos_bi::configure_and_start]',
          'recipe[blustratus::configure_and_start_web_console]'

# Attributes applied if the node doesn't have it set already.
## BLU Stratus
# default[:console][:install][:path]      = "/opt/ibm/dsserver"
# default[:console][:config_prefix]       = "/opt/ibm/dsserver"
# default[:console][:metadb][:directory]  = "/home/db2inst1"
# default[:swap][:file]                   = "/mnt/swap"

## Cognos
# default[:cognos][:config_path]          = '/'
# default[:cognos][:cm][:directory]       = '/home/db2inst1'
# default[:imcloud][:download_directory]  = '/mnt/blumeta0/downloads'

## DB2
# default[:db2][:install_prefix]      = "/"
# default[:db2][:data_path]           = "/mnt/bludata0/db2/databases"
# default[:db2][:backup_path]         = "/mnt/bludata0/db2/backup"
# default[:db2][:log_path]            = "/mnt/bludata0/db2/log"
# default[:db2][:home_path]            = "/home"

default_attributes 'db2' => {
                      'download_name' =>      'DB2 10.5.0.3 s140113',
                      'install_prefix' =>     '/mnt',
                      'data_path' =>          '/mnt/home/db2inst1',
                      'backup_path' =>        '/mnt/home/db2inst1/backup',
                      'log_path' =>           '/mnt/home/db2inst1/log',
                      'home_path' =>          '/mnt/home'
                    },
                    'cognos' => {
                      'install_fixpacks' =>   'YES',
                      'config_path' =>        '/mnt',
                      'cm' => {
                        'directory' =>        '/mnt/home/db2inst1'
                      }
                    },
                    'console' => {
                      'download_name' =>      'BLU Stratus Web Console',
                      'install' => {
                        'path' =>             '/mnt/opt/ibm/dsserver'
                      },
                      'config_prefix' =>      '/mnt/opt/ibm/dsserver',
                      'metadb' => {
                        'directory' =>        '/mnt/home/db2inst1'
                      }
                    },
                    'cloud' => {
                      'provider' =>           'AWS'
                    },
                    'ldap' => {
                      'first' =>              'YES'
                    },
                    'imcloud' => {
                      'api' => {
                        'key' =>              '2f085845cae03d084f1f522ce1a0c9c49f4374f15da192783872bc23cff17ee4',
                        'url' =>              'https://staging.imdemocloud.com/api'
                      },
                      'download_directory' => '/mnt/downloads'
                    }

# Attributes applied no matter what the node has set already.
override_attributes()
