# This file allows users to call find_package(Polly) and pick up our targets.

find_package(LLVM REQUIRED CONFIG
             HINTS "/Users/vsk/src/llvm.org-master/final/Phase3/Release/llvmCore-7.0.0-final.obj/lib/cmake/llvm")

set(Polly_CMAKE_DIR ${CMAKE_CURRENT_LIST_DIR})
set(Polly_BUNDLED_ISL ON)
set(Polly_ENABLE_GPGPU_CODEGEN OFF)

set(Polly_DEFINITIONS ${LLVM_DEFINITIONS})
set(Polly_INCLUDE_DIRS /usr/local/include;/usr/local/include/polly ${LLVM_INCLUDE_DIRS})
set(Polly_LIBRARY_DIRS /usr/local/lib)
set(Polly_EXPORTED_TARGETS Polly;PollyISL;LLVMPolly)
set(Polly_LIBRARIES ${LLVM_LIBRARIES} ${Polly_EXPORTED_TARGETS})

# Imported Targets:

if (NOT TARGET PollyISL)
  add_library(PollyISL STATIC IMPORTED)
endif()

if (Polly_ENABLE_GPGPU_CODEGEN AND NOT TARGET PollyPPCG)
  add_library(PollyPPCG  IMPORTED)
  set_property(TARGET PollyPPCG PROPERTY INTERFACE_LINK_LIBRARIES PollyISL)
endif()

if (NOT TARGET Polly)
  add_library(Polly STATIC IMPORTED)
  set_property(TARGET Polly PROPERTY INTERFACE_LINK_LIBRARIES PollyISL)
  if (Polly_ENABLE_GPGPU_CODEGEN)
    set_property(TARGET Polly APPEND PROPERTY INTERFACE_LINK_LIBRARIES PollyPPCG)
  endif()
endif()

if (NOT TARGET LLVMPolly)
  add_library(LLVMPolly MODULE IMPORTED)
  set_property(TARGET LLVMPolly PROPERTY INTERFACE_LINK_LIBRARIES Polly)
endif()

# Exported locations:
file(GLOB CONFIG_FILES "${Polly_CMAKE_DIR}/PollyExports-*.cmake")
foreach(f ${CONFIG_FILES})
  include(${f})
endforeach()
