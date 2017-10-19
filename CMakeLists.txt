cmake_minimum_required(VERSION 2.8)

macro(ADD_BUNDLE_RESOURCES _target)
  set(_resources ${ARGN})
  foreach(_resource ${_resources})
    target_sources(${_target} PRIVATE ${_resource})
    set_source_files_properties(${_resource} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
  endforeach()
endmacro()

project(iOSQtS3Upload)

# Find includes in the build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Turn on automatic invocation of the MOC
set(CMAKE_AUTOMOC ON)

# Add a compiler flag
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")

# Find the QtWidgets library
find_package(Qt5 COMPONENTS Core)

include("DoQtMess.cmake")

set(TEST_FILES
    test.txt
    test.bin
    test_processed.bin
)

# Tell CMake to create the executable
add_executable(iOSQtS3Upload main.m)

ADD_BUNDLE_RESOURCES(iOSQtS3Upload
    ${TEST_FILES}
)

set_target_properties(
    iOSQtS3Upload
    PROPERTIES
        MACOSX_BUNDLE YES
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/plist.in"
        XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon"
        XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME "LaunchImage"
        XCODE_ATTRIBUTE_BUNDLE_SHORT_VERSION_STRING "1.0.0"
        XCODE_ATTRIBUTE_PRODUCT_NAME "iOSQtS3Upload"
        XCODE_ATTRIBUTE_BUNDLE_LONG_VERSION_STRING "1.0.0"
        XCODE_ATTRIBUTE_VERSION_STRING "1.0.0"
        XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "siavash.developer"
        XCODE_ATTRIBUTE_COMBINE_HIDPI_IMAGES "NO"
        XCODE_ATTRIBUTE_HUMAN_READABLE_COPYRIGHT "MIT License"
)

# Add the Qt5 Core for linking
target_link_libraries(iOSQtS3Upload Qt5::Core ${QT_LIBRARIES})
