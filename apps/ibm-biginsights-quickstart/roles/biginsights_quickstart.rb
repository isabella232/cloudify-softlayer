name        'biginsights_quickstart'
description 'IBM BigInsights Quickstart'

run_list  'role[base]',
          'recipe[ibm_biginsights_quickstart]'

# Attributes applied no matter what the node has set already.
default_attributes  'imcloud' => {
                      'api' => {
                        'key' => '71b25a8274d595ffe00d96960d55f8acf8f2caf0b79c1f134c1b0d62739f2eeb',
                        'url' => 'https://my.imdemocloud.com/api'
                      }
                    }

# Attributes applied if the node doesn't have it set already.
override_attributes()
