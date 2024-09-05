cmake_minimum_required(VERSION 3.16)
project(VSpiritMusic VERSION 0.1 LANGUAGES CXX)
include(GitCommitVersion.cmake)
get_git_version()
configure_file(
    ${CMAKE_SOURCE_DIR}/src/version.h.in
    ${CMAKE_BINARY_DIR}/export/version.h
)
add_subdirectory(src)
