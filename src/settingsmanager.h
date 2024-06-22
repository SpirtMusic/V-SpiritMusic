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
