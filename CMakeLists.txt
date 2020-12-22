## CMake build originated by: NCrookston July 24 2012

cmake_minimum_required (VERSION 3.12)

enable_language(Fortran)
project(Open-FVS)

# Default variable values which can be set on the command line
set(FVS_VARIANTS "pn,wc" CACHE STRING "FVS variants to configure, eg. pnc,wcc,oc,op")
string(TOLOWER ${FVS_VARIANTS} FVS_VARIANTS)

# Convert the variants string to a CMake list
string(REPLACE "," ";" FVS_VARIANTS "${FVS_VARIANTS}")
string(REPLACE " " ";" FVS_VARIANTS "${FVS_VARIANTS}")

message(STATUS "Configure FVS Variants: ${FVS_VARIANTS}")

foreach (variant ${FVS_VARIANTS})

	set(target_name "FVS${variant}")
	set(sl "q${target_name}_sourceList.txt") # Using the q-variant source lists
	get_filename_component(slfn "bin/${sl}" ABSOLUTE)

	# Read the source file list
	file(STRINGS "${slfn}"  source_files  NEWLINE_CONSUME)
	
	string(REPLACE "../" "${CMAKE_CURRENT_LIST_DIR}/" source_files ${source_files})
	
	set(target_folder "${PROJECT_BINARY_DIR}/${target_name}")
	# Ensure the build folder is clean
	file(MAKE_DIRECTORY ${target_folder})
	# file(REMOVE ${target_folder}/CMakeLists.txt)
	# file(REMOVE ${target_folder}/CMakeCache.txt)
	# file(REMOVE ${target_folder}/sourcelist.txt)
	# file(REMOVE_RECURSE ${target_folder}/CMakeFiles)
	file(REMOVE_RECURSE ${target_folder})
	
	# Write the variant configuration files
	file(WRITE ${target_folder}/sourcelist.txt ${source_files})
	# message(${source_files})
	# message("Source list: ${target_name}/sourcelist.txt")
	
	set(header_message "**** DO NOT EDIT - This is an auto-generated file")
	
	# Perform variable substitution on the variant CMakeLists.txt
	# message("CmakeLists.txt: ${target_name}/CMakeLists.txt")
	configure_file(
		CMakeLists.txt.in
		${target_folder}/CMakeLists.txt
		@ONLY
		)
	
	message(STATUS "Configure subdirectory: ${target_folder}")
	add_subdirectory(${target_folder})
	
	add_custom_target(${variant} ALL DEPENDS lib${target_name} ${target_name} lib${target_name}_static)

endforeach(variant)

return()