cmake_minimum_required(VERSION 3.16)

project(vsonegx VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)
qt_policy(SET QTP0001 OLD)
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
    qml/controls/VLayerButton.qml
    qml/layouts/layers/VLayerContainer.qml
    qml/controls/VLayerControl.qml
    qml/views/Layers.qml
    qml/layouts/layers/VLayersControlContainer.qml
    qml/controls/VGroupBox.qml
    qml/controls/VKnob.qml
    qml/controls/VSplitView.qml
    qml/views/Settings.qml
    qml/layouts/settings/TabBarSettings.qml
    qml/controls/VSlider.qml
    RESOURCES
    qml/imgs/music.svg
    qml/imgs/sliders-h.svg
    qml/imgs/wrench.svg
    qml/imgs/cog.svg
    qml/imgs/midi.svg
    qml/imgs/info-circle.svg
    qml/imgs/th.svg
    qml/imgs/pencil-ruler.svg
    # qml/controls/resource/knob/Aqua/Aqua_128.png
    # qml/controls/resource/knob/Aqua/Aqua_30.png
    # qml/controls/resource/knob/Aqua/Aqua_40.png
    # qml/controls/resource/knob/Aqua/Aqua_50.png
    # qml/controls/resource/knob/Aqua/Aqua_85.png
    # qml/controls/resource/knob/Bluesbreaker/Bluesbreaker_128.png
    # qml/controls/resource/knob/Bluesbreaker/Bluesbreaker_30.png
    # qml/controls/resource/knob/Bluesbreaker/Bluesbreaker_40.png
    # qml/controls/resource/knob/Bluesbreaker/Bluesbreaker_50.png
    # qml/controls/resource/knob/Bluesbreaker/Bluesbreaker_85.png
    # qml/controls/resource/knob/Credence/Credence_128.png
    # qml/controls/resource/knob/Credence/Credence_30.png
    # qml/controls/resource/knob/Credence/Credence_40.png
    # qml/controls/resource/knob/Credence/Credence_50.png
    # qml/controls/resource/knob/Credence/Credence_85.png
    # qml/controls/resource/knob/FStyle/FStyle_128.png
    # qml/controls/resource/knob/FStyle/FStyle_30.png
    # qml/controls/resource/knob/FStyle/FStyle_40.png
    # qml/controls/resource/knob/FStyle/FStyle_50.png
    # qml/controls/resource/knob/FStyle/FStyle_85.png
    # qml/controls/resource/knob/Hexagonal/Hexagonal_128.png
    # qml/controls/resource/knob/Hexagonal/Hexagonal_30.png
    # qml/controls/resource/knob/Hexagonal/Hexagonal_40.png
    # qml/controls/resource/knob/Hexagonal/Hexagonal_50.png
    # qml/controls/resource/knob/Hexagonal/Hexagonal_85.png
    # qml/controls/resource/knob/Hippy/Hippy_128.png
    # qml/controls/resource/knob/Hippy/Hippy_30.png
    # qml/controls/resource/knob/Hippy/Hippy_40.png
    # qml/controls/resource/knob/Hippy/Hippy_50.png
    # qml/controls/resource/knob/Hippy/Hippy_85.png
    # qml/controls/resource/knob/kjLED/kjLED_128.png
    # qml/controls/resource/knob/kjLED/kjLED_30.png
    # qml/controls/resource/knob/kjLED/kjLED_40.png
    # qml/controls/resource/knob/kjLED/kjLED_50.png
    # qml/controls/resource/knob/kjLED/kjLED_85.png
    qml/controls/resource/knob/LittlePhatty/LittlePhatty_128.png
    qml/controls/resource/knob/LittlePhatty/LittlePhatty_30.png
    qml/controls/resource/knob/LittlePhatty/LittlePhatty_40.png
    qml/controls/resource/knob/LittlePhatty/LittlePhatty_50.png
    qml/controls/resource/knob/LittlePhatty/LittlePhatty_85.png
    # qml/controls/resource/knob/Oscar/Oscar_128.png
    # qml/controls/resource/knob/Oscar/Oscar_30.png
    # qml/controls/resource/knob/Oscar/Oscar_40.png
    # qml/controls/resource/knob/Oscar/Oscar_50.png
    # qml/controls/resource/knob/Oscar/Oscar_85.png
    # qml/controls/resource/knob/RedScale/RedScale_128.png
    # qml/controls/resource/knob/RedScale/RedScale_30.png
    # qml/controls/resource/knob/RedScale/RedScale_40.png
    # qml/controls/resource/knob/RedScale/RedScale_50.png
    # qml/controls/resource/knob/RedScale/RedScale_85.png
    # qml/controls/resource/knob/Silver/Silver_128.png
    # qml/controls/resource/knob/Silver/Silver_30.png
    # qml/controls/resource/knob/Silver/Silver_40.png
    # qml/controls/resource/knob/Silver/Silver_50.png
    # qml/controls/resource/knob/Silver/Silver_85.png
    # qml/controls/resource/knob/SSLish/SSLish_128.png
    # qml/controls/resource/knob/SSLish/SSLish_30.png
    # qml/controls/resource/knob/SSLish/SSLish_40.png
    # qml/controls/resource/knob/SSLish/SSLish_50.png
    # qml/controls/resource/knob/SSLish/SSLish_85.png
    # qml/controls/resource/knob/Vintage/Vintage_128.png
    # qml/controls/resource/knob/Vintage/Vintage_30.png
    # qml/controls/resource/knob/Vintage/Vintage_40.png
    # qml/controls/resource/knob/Vintage/Vintage_50.png
    # qml/controls/resource/knob/Vintage/Vintage_85.png
    # qml/controls/resource/knob/Wedge/Wedge_128.png
    # qml/controls/resource/knob/Wedge/Wedge_30.png
    # qml/controls/resource/knob/Wedge/Wedge_40.png
    # qml/controls/resource/knob/Wedge/Wedge_50.png
    # qml/controls/resource/knob/Wedge/Wedge_85.png

    qml/controls/resource/texture/tx3.jpg
    qml/controls/resource/effects/fog_effect.png
    qml/controls/resource/effects/onLayer.png
    qml/controls/resource/texture/button_texture.png
    qml/controls/resource/texture/main.png

    qml/controls/resource/slider/handler.png
    qml/controls/resource/slider/slider_handler_H.png
    qml/controls/resource/slider/slider_handler_V.png
    QML_FILES qml/controls/VPopup.qml
    QML_FILES qml/controls/VSliderPopup.qml
    QML_FILES qml/controls/VSliderPopupH.qml
    SOURCES settingsmanager.h settingsmanager.cpp
    QML_FILES qml/layouts/settings/settingsPages/ConnectionsPage.qml
    QML_FILES qml/controls/VComboBox.qml
    QML_FILES qml/controls/VButton.qml



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
