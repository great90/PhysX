##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions
## are met:
##  * Redistributions of source code must retain the above copyright
##    notice, this list of conditions and the following disclaimer.
##  * Redistributions in binary form must reproduce the above copyright
##    notice, this list of conditions and the following disclaimer in the
##    documentation and/or other materials provided with the distribution.
##  * Neither the name of NVIDIA CORPORATION nor the names of its
##    contributors may be used to endorse or promote products derived
##    from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
## EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
## PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
## CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
## PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
## OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
## (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
## OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##
## Copyright (c) 2018-2019 NVIDIA Corporation. All rights reserved.

#
# Build PhysXCooking
#

IF(NOT PX_GENERATE_STATIC_LIBRARIES)
	SET(PXCOOKING_LIBTYPE_DEFS
		PX_PHYSX_FOUNDATION_EXPORTS;PX_PHYSX_COMMON_EXPORTS;PX_PHYSX_COOKING_EXPORTS;PX_PHYSX_LOADER_EXPORTS;PX_PHYSX_CORE_EXPORTS
	)
ENDIF()

SET(PHYSXCOOKING_COMPILE_DEFS
	# Common to all configurations
	${PHYSX_WINDOWS_COMPILE_DEFS};PX_COOKING;${PXCOOKING_LIBTYPE_DEFS};${PHYSX_LIBTYPE_DEFS};${PHYSXGPU_LIBTYPE_DEFS}

	$<$<CONFIG:debug>:${PHYSX_WINDOWS_DEBUG_COMPILE_DEFS};>
	$<$<CONFIG:checked>:${PHYSX_WINDOWS_CHECKED_COMPILE_DEFS};>
	$<$<CONFIG:profile>:${PHYSX_WINDOWS_PROFILE_COMPILE_DEFS};>
	$<$<CONFIG:release>:${PHYSX_WINDOWS_RELEASE_COMPILE_DEFS};>

)

SET(PHYSX_COOKING_WINDOWS_SOURCE
	${LL_SOURCE_DIR}/windows/WindowsCookingDelayLoadHook.cpp
)
SOURCE_GROUP(src\\windows FILES ${PHYSX_COOKING_WINDOWS_SOURCE})

SET(PHYSX_COOKING_RESOURCE
	${PHYSX_SOURCE_DIR}/compiler/resource_${RESOURCE_LIBPATH_SUFFIX}/PhysXCooking.rc
)
SOURCE_GROUP(resource FILES ${PHYSX_COOKING_RESOURCE})

SET(PHYSXCOOKING_PLATFORM_SRC_FILES 
	${PHYSX_COOKING_WINDOWS_SOURCE}
	${PHYSX_COOKING_RESOURCE}
)

IF(PX_GENERATE_STATIC_LIBRARIES)
	SET(PHYSXCOOKING_LIBTYPE STATIC)
ELSE()
	SET(PHYSXCOOKING_LIBTYPE SHARED)	
ENDIF()

IF(NV_USE_GAMEWORKS_OUTPUT_DIRS AND PHYSXCOOKING_LIBTYPE STREQUAL "STATIC")
	SET(PHYSXCOOKING_COMPILE_PDB_NAME_DEBUG "PhysXCooking_static${CMAKE_DEBUG_POSTFIX}")
	SET(PHYSXCOOKING_COMPILE_PDB_NAME_CHECKED "PhysXCooking_static${CMAKE_CHECKED_POSTFIX}")
	SET(PHYSXCOOKING_COMPILE_PDB_NAME_PROFILE "PhysXCooking_static${CMAKE_PROFILE_POSTFIX}")
	SET(PHYSXCOOKING_COMPILE_PDB_NAME_RELEASE "PhysXCooking_static${CMAKE_RELEASE_POSTFIX}")
ELSE()
	SET(PHYSXCOOKING_COMPILE_PDB_NAME_DEBUG "PhysXCooking${CMAKE_DEBUG_POSTFIX}")
	SET(PHYSXCOOKING_COMPILE_PDB_NAME_CHECKED "PhysXCooking${CMAKE_CHECKED_POSTFIX}")
	SET(PHYSXCOOKING_COMPILE_PDB_NAME_PROFILE "PhysXCooking${CMAKE_PROFILE_POSTFIX}")
	SET(PHYSXCOOKING_COMPILE_PDB_NAME_RELEASE "PhysXCooking${CMAKE_RELEASE_POSTFIX}")
ENDIF()

IF(PHYSXCOOKING_LIBTYPE STREQUAL "SHARED")
	INSTALL(FILES $<TARGET_PDB_FILE:PhysXCooking> 
		DESTINATION $<$<CONFIG:debug>:${PX_ROOT_LIB_DIR}/debug>$<$<CONFIG:release>:${PX_ROOT_LIB_DIR}/release>$<$<CONFIG:checked>:${PX_ROOT_LIB_DIR}/checked>$<$<CONFIG:profile>:${PX_ROOT_LIB_DIR}/profile> OPTIONAL)
ELSE()
	INSTALL(FILES ${PHYSX_ROOT_DIR}/$<$<CONFIG:debug>:${PX_ROOT_LIB_DIR}/debug>$<$<CONFIG:release>:${PX_ROOT_LIB_DIR}/release>$<$<CONFIG:checked>:${PX_ROOT_LIB_DIR}/checked>$<$<CONFIG:profile>:${PX_ROOT_LIB_DIR}/profile>/$<$<CONFIG:debug>:${PHYSXCOOKING_COMPILE_PDB_NAME_DEBUG}>$<$<CONFIG:checked>:${PHYSXCOOKING_COMPILE_PDB_NAME_CHECKED}>$<$<CONFIG:profile>:${PHYSXCOOKING_COMPILE_PDB_NAME_PROFILE}>$<$<CONFIG:release>:${PHYSXCOOKING_COMPILE_PDB_NAME_RELEASE}>.pdb
		DESTINATION $<$<CONFIG:debug>:${PX_ROOT_LIB_DIR}/debug>$<$<CONFIG:release>:${PX_ROOT_LIB_DIR}/release>$<$<CONFIG:checked>:${PX_ROOT_LIB_DIR}/checked>$<$<CONFIG:profile>:${PX_ROOT_LIB_DIR}/profile> OPTIONAL)	
ENDIF()

SET(PHYSXCOOKING_LINK_FLAGS "/MAP")
SET(PHYSXCOOKING_LINK_FLAGS_DEBUG "/DELAYLOAD:PhysXFoundation${CMAKE_DEBUG_POSTFIX}.dll /DELAYLOAD:PhysXCommon${CMAKE_DEBUG_POSTFIX}.dll")
SET(PHYSXCOOKING_LINK_FLAGS_CHECKED "/DELAYLOAD:PhysXFoundation${CMAKE_CHECKED_POSTFIX}.dll /DELAYLOAD:PhysXCommon${CMAKE_CHECKED_POSTFIX}.dll")
SET(PHYSXCOOKING_LINK_FLAGS_PROFILE "/DELAYLOAD:PhysXFoundation${CMAKE_PROFILE_POSTFIX}.dll /DELAYLOAD:PhysXCommon${CMAKE_PROFILE_POSTFIX}.dll")
SET(PHYSXCOOKING_LINK_FLAGS_RELEASE "/DELAYLOAD:PhysXFoundation${CMAKE_RELEASE_POSTFIX}.dll /DELAYLOAD:PhysXCommon${CMAKE_RELEASE_POSTFIX}.dll")		
