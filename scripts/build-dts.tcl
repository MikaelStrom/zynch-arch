set HDF [lindex $argv 0]

open_hw_design ${HDF}
set_repo_path trees/device-tree-xlnx
create_sw_design device-tree -os device_tree -proc ps7_cortexa9_0
generate_target -dir dt
