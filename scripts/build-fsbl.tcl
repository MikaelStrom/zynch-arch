set HDF [lindex $argv 0]

platform create -name hw -hw ${HDF} -os standalone -proc psu_cortexa53_0 -out fsbl
platform generate
