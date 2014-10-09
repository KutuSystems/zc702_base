
# Set the original project directory path for adding/importing sources in the new project
set orig_proj_dir "../zc702_base"

# Create project
create_project -force zc702_base ../zc702_base

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects zc702_base]
set_property "board" "xilinx.com:zynq:zc702:1.0" $obj
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "VHDL" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Add files to 'sources_1' fileset
add_files -norecurse sources/sources_1/top_zc702/top_zc702.vhd

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "top" "top_zc702" $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Add files to 'constrs_1' fileset
add_files -norecurse sources/constrs_1/system_top_zc702.xdc

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets sim_1] ""]} {
  create_fileset -simset sim_1
}

# Add files to 'sim_1' fileset
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "top" "top_zc702" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs synth_1] ""]} {
  create_run -name synth_1 -part xc7z045ffg900-2 -flow {Vivado Synthesis 2013} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
}
set obj [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs impl_1] ""]} {
  create_run -name impl_1 -part xc7z045ffg900-2 -flow {Vivado Implementation 2013} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
}
set obj [get_runs impl_1]


puts "INFO: Project created:zc702_base"

# Add IP location
set_property ip_repo_paths  ../XilinxIP [current_fileset]
update_ip_catalog

# Create block diagram
source scripts/system_top_bd.tcl

# Create block diagram wrapper
make_wrapper -files [get_files ../zc702_base/zc702_base.srcs/sources_1/bd/system_top/system_top.bd] -top
add_files -norecurse ../zc702_base/zc702_base.srcs/sources_1/bd/system_top/hdl/system_top_wrapper.vhd
update_compile_order -fileset sources_1

# generate output products
update_compile_order -fileset sources_1
generate_target all [get_files  ../zc702_base/zc702_base.srcs/sources_1/bd/system_top/system_top.bd]

