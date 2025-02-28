# Version:V1.0
# Date: 27/12/2024
# Author: Cursor
#
#Function Description: 
#   Create and configure a Vivado project, including adding source files, 
# IP cores, constraint files, and BD design files, then perform synthesis, 
# implementation, and generate bitstream and MCS files.
# Parameter Description:
#   project_path: The storage path for the project
#   project_name: The name of the project
#   device: FPGA device model
#   src_path: Source file path (supports multi-level directories)
#   xdc_path: Constraint file path
#   ip_path: IP core file path (supports subdirectories)
#   bd_path: BD design file path
#   flash_type: FLASH interface type (used for generating MCS file). 
#   Valid values include SMAPx8 (default), SMAPx16, SMAPx32,
#   SERIALx1, SPIx1, SPIx2, SPIx4, SPIx8, BPIx8, BPIx16.
#   flash_size: FLASH size (used for generating MCS file). 
#   Specify the size limit in MBytes of the PROM device that is being targeted. 
#   The size must be specified as a power of 2.
# Example Usage:
#   vvd_pargen "C:/projects/my_project" "my_project" "xc7z020clg484-1" \
#   "C:/src" "C:/constraints" "C:/ips" "C:/bd" "SPIx4" "16MB"
#
#
proc vvd_pargen {project_path project_name device src_path xdc_path ip_path bd_path out_path flash_type flash_size add_syntime} {
    # Close the currently open project
    if {[current_project -quiet] ne ""} {
        close_project -delete
    }
    # Delete all files in the project path
    if {[file exists $project_path]} {
        file delete -force $project_path/*
    } else {
        file mkdir $project_path
    }

    # Create a new Vivado project
    create_project $project_name $project_path -part $device -force

    set_param general.maxThreads 6
    set_param general.legalFilePathCheckRelaxed 1
    set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY XPM_FIFO} [current_project ]

    # Add source files (supports multi-level paths)
    proc add_source_files {path} {
        foreach item [glob -nocomplain -directory $path -type {f d} *] {
            if {[file isdirectory $item]} {
                add_source_files $item
            } elseif {[file extension $item] in {.v .vh .sv}} {
                add_files $item
            }
        }
    }

    if {$add_syntime == "on"} {
        set init_vh "$src_path/usl2c128_ver.vh"
        if {![file exists $init_vh]} {
            file mkdir [file dirname $init_vh]
            set fid [open $init_vh w]
            close $fid
        }
        if {[file exists $init_vh]} {
            set timestamp [clock format [clock seconds] -format {%Y%m%d%H%M%S}]
            set timestamp_h [string range $timestamp 0 7]
            set timestamp_l [string range $timestamp 8 13]
            
            # 获取当前TCL工作路径下的svn版本号
            set svn_version [exec svnversion -c]
            set svn_version [string trim $svn_version "-m"]
            set svn_version [regsub {^[0-9]+:([0-9]+)M$} $svn_version {\1}]
            
            set fid [open $init_vh r]
            set lines [split [read $fid] "\n"]
            close $fid

            set new_lines {}
            set found_build_time_h 0
            set found_build_time_l 0
            set found_svn_ver 0

            foreach line $lines {
                if {[string match "`define _BUILD_TIME_H_*" $line]} {
                    lappend new_lines "`define _BUILD_TIME_H_ 32'h$timestamp_h"
                    set found_build_time_h 1
                } elseif {[string match "`define _BUILD_TIME_L_*" $line]} {
                    lappend new_lines "`define _BUILD_TIME_L_ 32'h[string repeat 0 [expr {6 - [string length $timestamp_l]}]]$timestamp_l"
                    set found_build_time_l 1
                } elseif {[string match "`define _SVN_VER_*" $line]} {
                    lappend new_lines "`define _SVN_VER_ 32'h[string repeat 0 [expr {4 - [string length $svn_version]}]]$svn_version"
                    set found_svn_ver 1
                } else {
                    lappend new_lines $line
                }
            }

            if {!$found_build_time_h} {
                lappend new_lines "`define _BUILD_TIME_H_ 32'h$timestamp_h"
            }
            if {!$found_build_time_l} {
                lappend new_lines "`define _BUILD_TIME_L_ 32'h[string repeat 0 [expr {6 - [string length $timestamp_l]}]]$timestamp_l"
            }
            if {!$found_svn_ver} {
                lappend new_lines "`define _SVN_VER_ 32'h[string repeat 0 [expr {4 - [string length $svn_version]}]]$svn_version"
            }

            set fid [open $init_vh w]
            puts $fid [join $new_lines "\n"]
            close $fid
        }
    }
   
    if {[file exists $src_path]} {
        add_source_files $src_path
    }

    
    # Add IP cores (supports subdirectories)
    if {[file exists $ip_path]} {
        set ip_files [glob -nocomplain -directory $ip_path -type f -tails **/*.xci]
        if {[llength $ip_files] > 0} {
            set ip_full_paths {}
            foreach file $ip_files {
                lappend ip_full_paths [file join $ip_path $file]
            }
            add_files -norecurse [lsort -unique $ip_full_paths]
        }
    }

    # Add XDC constraint files
    if {[file exists $xdc_path]} {
        set xdc_files [glob -nocomplain -directory $xdc_path -type f -tails *.xdc]
        if {[llength $xdc_files] > 0} {
            set xdc_full_paths {}
            foreach file $xdc_files {
                lappend xdc_full_paths [file join $xdc_path $file]
            }
            add_files -norecurse [lsort -unique $xdc_full_paths]
        }
    }

    # Add BD design files
    if {[file exists $bd_path]} {
        set bd_files [glob -nocomplain -directory $bd_path -type f -tails **/*.bd]
        if {[llength $bd_files] > 0} {
            set bd_full_paths {}
            foreach file $bd_files {
                lappend bd_full_paths [file join $bd_path $file]
            }
            import_files -fileset sources_1 [lsort -unique $bd_full_paths]
        }
    }

    # Check and create debug.xdc file
    set debug_xdc "$xdc_path/debug.xdc"
    if {![file exists $debug_xdc]} {
        set fid [open $debug_xdc w]
        close $fid
    }
    set_property target_constrs_file $debug_xdc [current_fileset -constrset]

    # Run synthesis
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1

    # Run implementation
    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1

    set curtime [clock seconds]
    set formattime [clock format $curtime -format {%y%m%d_%H%M}]
    set dir_gen ${out_path}/$formattime
    file mkdir $dir_gen

    open_run impl_1
    # Generate download file
    write_bitstream -force $dir_gen/$project_name.bit
    write_debug_probes -force $dir_gen/$project_name.ltx

    # Generate MCS file based on FLASH type and size
    if {$flash_type != "" && $flash_size != ""} {
        write_cfgmem -force -format mcs -interface $flash_type -size $flash_size -loadbit \
        "up 0x0 $dir_gen/$project_name.bit" -file $dir_gen/$project_name.mcs
    }

  #  if { [file exists ${dir_gen}/debug_nets.ltx]} {
  #      file copy -force ${dir_gen}/debug_nets.ltx    $dir_gen/debug_nets.ltx
  #  }    
}

