# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

project(update_installer LANGUAGES CXX)

cmake_policy(VERSION 3.14...3.25)

set(PLUGIN_NAME "update_installer_plugin")
set(UPDATER_NAME "MeloTripUpdater")

list(APPEND PLUGIN_SOURCES
  "update_installer_plugin.cpp"
  "update_installer_plugin.h"
)

add_library(${PLUGIN_NAME} SHARED
  "include/update_installer/update_installer_plugin_c_api.h"
  "update_installer_plugin_c_api.cpp"
  ${PLUGIN_SOURCES}
)

apply_standard_settings(${PLUGIN_NAME})

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)

add_executable(${UPDATER_NAME} WIN32
  "updater/updater_main.cpp"
)

apply_standard_settings(${UPDATER_NAME})
target_link_libraries(${UPDATER_NAME} PRIVATE comctl32 d2d1 dwrite dwmapi ole32 shell32)

set(update_installer_bundled_libraries
  $<TARGET_FILE:${UPDATER_NAME}>
  PARENT_SCOPE
)

# === Tests ===
if (${include_update_installer_tests})
set(TEST_RUNNER "update_installer_test")
enable_testing()

include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
set(INSTALL_GTEST OFF CACHE BOOL "Disable installation of googletest" FORCE)
FetchContent_MakeAvailable(googletest)

add_executable(${TEST_RUNNER}
  test/update_installer_plugin_test.cpp
)
apply_standard_settings(${TEST_RUNNER})
target_include_directories(${TEST_RUNNER} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(${TEST_RUNNER} PRIVATE flutter_wrapper_plugin gtest_main gmock)
add_custom_command(TARGET ${TEST_RUNNER} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  "${FLUTTER_LIBRARY}" $<TARGET_FILE_DIR:${TEST_RUNNER}>
)
include(GoogleTest)
gtest_discover_tests(${TEST_RUNNER})
endif()