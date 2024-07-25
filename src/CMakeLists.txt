cmake_minimum_required(VERSION 3.16)

project(VSpirtMusic VERSION 0.1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)
include(qml_files.cmake)
include(resources.cmake)
qt_policy(SET QTP0001 OLD)
qt_standard_project_setup()
set(LIBREMIDI_NO_WINUWP 0)
find_package(libremidi REQUIRED)
add_definitions(-DLIBREMIDI_HEADER_ONLY=1)
add_definitions(-DLIBREMIDI_JACK=1)
qt_add_resources(VSpirtMusic


)
qt_add_executable(VSpirtMusic
    main.cpp
)
#set_source_files_properties(qml/themes/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
qt_add_qml_module(VSpirtMusic
    URI vsonegx
    VERSION 1.0
    QML_FILES ${QML_FILES}
    RESOURCES ${RESOURCE_FILES}
    SOURCES settingsmanager.h settingsmanager.cpp
    SOURCES backend/jackclient.h backend/jackclient.cpp
    SOURCES backend/midiclient.h backend/midiclient.cpp
    SOURCES backend/midiutils.h
    SOURCES backend/midiportmodel.h backend/midiportmodel.cpp
    RESOURCES qml/imgs/icon-refresh.svg
    QML_FILES qml/controls/VChannelIndicator.qml
    QML_FILES qml/views/Sounds.qml
    QML_FILES qml/layouts/sounds/VSoundsCategories.qml
    QML_FILES qml/layouts/sounds/VSoundsContainer.qml
    RESOURCES qml/imgs/cil-trash.svg qml/imgs/cil-plus.svg qml/imgs/cil-pencil.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(VSpirtMusic PROPERTIES
    #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appvsonegx
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(VSpirtMusic
    PRIVATE Qt6::Quick
    jack
)

include(GNUInstallDirs)
install(TARGETS VSpirtMusic
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
