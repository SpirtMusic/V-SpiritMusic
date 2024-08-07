#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <settingsmanager.h>
#include <backend/midiclient.h>
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
    qputenv("QML_XHR_ALLOW_FILE_WRITE", QByteArray("1"));
     qputenv("QML_XHR_DUMP", QByteArray("1"));
    qmlRegisterType<SettingsManager>("com.sonegx.settingsmanager", 1, 0, "SettingsManager");
    qmlRegisterType<MidiClient>("com.sonegx.midiclient", 1, 0, "MidiClient");
    qmlRegisterSingletonType( QUrl(QStringLiteral("qrc:/vsonegx/qml/themes/Theme.qml")), "Theme", 1, 0, "Theme" );
    const QUrl url(QStringLiteral("qrc:/vsonegx/qml/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
