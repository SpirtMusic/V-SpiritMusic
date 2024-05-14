cmake_minimum_required(VERSION 3.16)

project(vsonegx VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()
qt_add_resources(appvsonegx


)
qt_add_executable(appvsonegx
    main.cpp
)
#set_source_files_properties(qml/themes/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
qt_add_qml_module(appvsonegx
    URI vsonegx
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/themes/Theme.qml
        qml/controls/VTabButton.qml
        qml/layouts/VTabBar.qml
    RESOURCES
        qml/imgs/music.svg
        qml/imgs/sliders-h.svg
        qml/imgs/wrench.svg
        qml/imgs/cog.svg
        qml/controls/VLayerButton.qml
        qml/layouts/VLayerContainer.qml
        qml/controls/VLayerControl.qml
        qml/views/Voices.qml
        qml/layouts/VLayersControlContainer.qml
        qml/controls/VGroupBox.qml
        qml/views/VoicesLayout1.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appvsonegx PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appvsonegx
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appvsonegx
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appvsonegx
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
