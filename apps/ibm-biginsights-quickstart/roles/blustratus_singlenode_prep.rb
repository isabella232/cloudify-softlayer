name        'blustratus_singlenode_prep'
description 'Prepare server for BLU Stratus singlenode deployment'

run_list  'role[base]',
          'recipe[blustratus::configure_os]'

# Attributes applied if the node doesn't have it set already.
default_attributes()

# Attributes applied no matter what the node has set already.
override_attributes()
