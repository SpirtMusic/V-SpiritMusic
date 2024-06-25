#include "settingsmanager.h"
SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent),
    settings(new QSettings(QSettings::IniFormat, QSettings::UserScope, "SonegGX", "VSoneGX")),
    saveTimer(new QTimer(this))
{
    connect(saveTimer, &QTimer::timeout, this, &SettingsManager::saveSettings);
    saveTimer->setSingleShot(true);
}

int SettingsManager::getControlVolume(int controlIndex) const
{
    return settings->value(QString("controlVolume/c_%1").arg(controlIndex), 0).toInt();
}

void SettingsManager::setControlVolume(int controlIndex, int value)
{
    scheduleSettingSave(QString("controlVolume/c_%1").arg(controlIndex), value);
}

int SettingsManager::getControlReverb(int controlIndex) const
{
    return settings->value(QString("controlReverb/c_%1").arg(controlIndex), 0).toInt();
}

void SettingsManager::setControlReverb(int controlIndex, int value)
{
    scheduleSettingSave(QString("controlReverb/c_%1").arg(controlIndex), value);
}


void SettingsManager::saveSelectedInput(const QString &name)
{
    scheduleSettingSave("MidiInput/Input", name);
}

void SettingsManager::saveSelectedOutput(const QString &name)
{
    scheduleSettingSave("MidiOutput/Output", name);
}

QString SettingsManager::loadSelectedInput()
{
    return settings->value("MidiInput/Input", "").toString();
}

QString SettingsManager::loadSelectedOutput()
{
    return settings->value("MidiOutput/Output", "").toString();
}

void  SettingsManager::saveLayerEnabled(int layerSet, int layerNumber, bool enabled){
    QString key = QString("LayerSettings/Set%1_Layer%2").arg(layerSet).arg(layerNumber);
    scheduleSettingSave(key, enabled);
}

bool SettingsManager::getLayerEnabled(int layerSet, int layerNumber) const{
    QString key = QString("LayerSettings/Set%1_Layer%2").arg(layerSet).arg(layerNumber);
    return settings->value(key, false).toBool();
}
void SettingsManager::scheduleSettingSave(const QString &key, const QVariant &value)
{
    pendingSettings[key] = value;
    if (!saveTimer->isActive()) {
        saveTimer->start(saveDelay);
    }
}

void SettingsManager::saveSettings()
{
    QMap<QString, QVariant>::iterator it;
    for (it = pendingSettings.begin(); it != pendingSettings.end(); ++it) {
        settings->setValue(it.key(), it.value());
    }
    pendingSettings.clear();
}
