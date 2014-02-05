name "base"
description "Base server"

run_list  "recipe[imcloud_tools::clean_yum_repo]",
          "recipe[imcloud_tools]",
          "recipe[dc_logger::install_client]",
          "recipe[imcloud_client]"

# Attributes applied if the node doesn't have it set already.
default_attributes()

# Attributes applied no matter what the node has set already.
override_attributes()
