cmake_minimum_required(VERSION 3.14)

project(window_title_bar LANGUAGES CXX)

cmake_policy(VERSION 3.14...3.25)

set(PLUGIN_NAME "window_title_bar_plugin")

add_library(${PLUGIN_NAME} SHARED
  "include/window_title_bar/window_title_bar_plugin_c_api.h"
  "window_title_bar_plugin.cpp"
  "window_title_bar_plugin.h"
  "window_title_bar_plugin_c_api.cpp"
)

apply_standard_settings(${PLUGIN_NAME})

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)
target_link_libraries(${PLUGIN_NAME} PRIVATE dwmapi)
