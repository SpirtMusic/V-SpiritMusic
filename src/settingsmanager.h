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

    Q_INVOKABLE void saveRawOutputCCEnabled(const QString &cc_id, bool enabled);
    Q_INVOKABLE void saveRawOutputPCEnabled(const QString &pc_id, bool enabled);

    Q_INVOKABLE bool getRawOutputCCEnabled(const QString &cc_id) const;
    Q_INVOKABLE bool getRawOutputPCEnabled(const QString &pc_id) const;


    Q_INVOKABLE bool getLayerEnabled(int layerSet, int layerNumber) const;
    Q_INVOKABLE QString loadSelectedInput();
    Q_INVOKABLE QString loadSelectedOutput();

    // Categories
    Q_INVOKABLE QStringList getCategories() const;
    Q_INVOKABLE int saveCategory(const QString &name, int mode, const QString &oldName = QString());
    Q_INVOKABLE void deleteCategory(const QString &name);

    Q_INVOKABLE QStringList getSoundsForCategory(const QString &category) const;
    Q_INVOKABLE int saveSound(const QString &category, const QString &name, int msb, int lsb, int pc) ;
    Q_INVOKABLE QVariantMap getSoundDetails(const QString &category, const QString &name) const ;
    Q_INVOKABLE bool deleteSound(const QString &category, const QString &name);

signals:
    void categoriesLoaded();

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
