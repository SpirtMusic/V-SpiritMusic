#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>
#include <QTimer>
#include <QMap>
class SettingsManager : public QObject
{
    Q_OBJECT
public:
    explicit SettingsManager(QObject *parent = nullptr);

    Q_INVOKABLE int getControlVolume(int controlIndex) const;
    Q_INVOKABLE void setControlVolume(int controlIndex, int value);
    Q_INVOKABLE int getControlReverb(int controlIndex) const;
    Q_INVOKABLE  void setControlReverb(int controlIndex, int value);
    Q_INVOKABLE void saveSelectedInput(const QString &name);
    Q_INVOKABLE void saveSelectedOutput(const QString &name);
    Q_INVOKABLE void saveLayerEnabled(int layerSet, int layerNumber, bool enabled);
    Q_INVOKABLE bool getLayerEnabled(int layerSet, int layerNumber) const;
    Q_INVOKABLE QString loadSelectedInput();
    Q_INVOKABLE QString loadSelectedOutput();

private slots:
    void saveSettings();

private:
    QSettings *settings;
    QTimer *saveTimer;
    QMap<QString, QVariant> pendingSettings;
    int saveDelay = 500; // Delay in milliseconds

    void scheduleSettingSave(const QString &key, const QVariant &value);
};

#endif // SETTINGSMANAGER_H
