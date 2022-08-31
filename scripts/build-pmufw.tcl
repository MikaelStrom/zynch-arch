set HDF [lindex $argv 0]

set hw_design [hsi open_hw_design ${HDF}]

set sw_design [hsi create_sw_design pmufw -proc psu_pmu_0 -os standalone]
hsi set_property CONFIG.stdin  psu_uart_1 [hsi get_os]
hsi set_property CONFIG.stdout psu_uart_1 [hsi get_os]
hsi add_library xilfpga
hsi add_library xilsecure
hsi add_library xilskey
hsi generate_app -hw $hw_design -sw $sw_design -app zynqmp_pmufw -compile -dir pmufw
hsi close_sw_design $sw_design
