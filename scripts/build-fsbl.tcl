set HDF [lindex $argv 0]

set design [open_hw_design ${HDF}]
generate_app -hw $design -os standalone -proc ps7_cortexa9_0 -app zynq_fsbl -compile -sw fsbl -dir fsbl
