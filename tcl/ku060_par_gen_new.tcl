set dir_work [pwd]
set name_par "top"
set dev_fpga "xcku060-ffva1156-2-i"

cd $dir_work

source ./tcl/vvd_pargen.tcl

vvd_pargen \
"./par" \
$name_par \
$dev_fpga \
"./src" \
"./xdc" \
"./ip" \
"./bd" \
"./out" \
"SPIx4" "512" \
"on"







