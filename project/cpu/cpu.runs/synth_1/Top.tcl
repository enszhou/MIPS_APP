# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.cache/wt [current_project]
set_property parent.project_path D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/Dev/HardWare/MIPS_APP/project/cpu/cpu.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files D:/Dev/HardWare/MIPS_APP/project/inst_rom.coe
read_verilog -library xil_defaultlib {
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/imports/new/ALU.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/new/ALUControlUnit.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/imports/Module/CLK.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/new/CPU.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/new/CPU_MEM.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/new/ControlUnit.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/new/DDU.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/new/HC_42.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/new/MEM.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/new/MUL_SIN.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/imports/new/Reg_File.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/imports/Module/SEG.v
  D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/new/Top.v
}
read_ip -quiet D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all d:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all d:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all d:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

read_ip -quiet D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0.xci
set_property used_in_implementation false [get_files -all d:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/constrs_1/imports/Module/Nexys4DDR_Master.xdc
set_property used_in_implementation false [get_files D:/Dev/HardWare/MIPS_APP/project/cpu/cpu.srcs/constrs_1/imports/Module/Nexys4DDR_Master.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top Top -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Top_utilization_synth.rpt -pb Top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
