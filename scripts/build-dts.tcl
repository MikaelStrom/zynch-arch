set HDF [lindex $argv 0]

hsi::open_hw_design ${HDF}
hsi::set_repo_path trees/device-tree-xlnx
hsi::create_sw_design device-tree -os device_tree -proc psu_cortexa53_0 
hsi::generate_target -dir dt
