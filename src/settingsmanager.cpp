#include "settingsmanager.h"
SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent),
    settings(new QSettings(QSettings::IniFormat, QSettings::UserScope, "SpiritMusic", "VSpiritMusic")),
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

QStringList SettingsManager::getCategories() const
{
    return settings->value("Categories/Categories").toStringList();
}
QStringList SettingsManager::getSubCategories(const QString &main_name) const
{
    QString category = QString("Categories/%1").arg(main_name);

    return settings->value(category).toStringList();
}
int SettingsManager::saveCategory(const QString &name, int mode, const QString &oldName, bool isMain,int level)
{
    QStringList categories = getCategories();

    if (mode == 0) {
        // Add mode
        if (!categories.contains(name)) {
            categories.append(name);
            scheduleSettingSave("Categories/Categories", categories);
            QString mode = QString("Categories/%1_isMain").arg(name);
            QString level_category = QString("Categories/%1_level").arg(name);
            scheduleSettingSave(mode, isMain);
            scheduleSettingSave(level_category, level);
            return 0; // Success
        } else {
            return 1; // Category already exists
        }
    } else if (mode == 1) {
        // Edit mode
        int index = categories.indexOf(oldName);
        if (index != -1) {
            if (name != oldName && categories.contains(name)) {
                return 2; // New name already exists
            }

            // Rename sounds associated with the old category
            QStringList sounds = getSoundsForCategory(oldName);
            for (const QString &sound : sounds) {
                QVariantMap soundDetails = getSoundDetails(oldName, sound);
                settings->remove("Sounds/" + oldName + "/" + sound);
                settings->setValue("Sounds/" + name + "/" + sound, soundDetails);
            }

            // Remove old category key
            settings->remove("Sounds/" + oldName);

            // Update category name in the list
            categories[index] = name;
            scheduleSettingSave("Categories/Categories", categories);

            // Rename the category section
            settings->beginGroup("Sounds");
            settings->remove(oldName);
            settings->endGroup();
            settings->beginGroup("Sounds");
            settings->setValue(name, sounds);
            settings->endGroup();

            return 0; // Success
        } else {
            return 3; // Old category not found
        }
    }

    return 4; // Invalid mode
}
int SettingsManager::saveSubCategory(const QString &main_name,const QString &name, int mode, const QString &oldName)
{
    QStringList categories = getSubCategories(main_name);

    if (mode == 0) {
        // Add mode
        if (!categories.contains(name)) {
            categories.append(name);
            QString category = QString("Categories/%1").arg(main_name);
            scheduleSettingSave(category, categories);
            return 0; // Success
        } else {
            return 1; // Category already exists
        }
    } else if (mode == 1) {
        // Edit mode
        qDebug()<<categories;
        int index = categories.indexOf(oldName);
        if (index != -1) {
            if (name != oldName && categories.contains(name)) {
                return 2; // New name already exists
            }

            // Rename sounds associated with the old category
            QStringList sounds = getSoundsForSubCategory(main_name,oldName);
            for (const QString &sound : sounds) {
                QVariantMap soundDetails = getSoundSubDetails(main_name,oldName, sound);
                settings->remove("Sounds/" +main_name+"/"+ oldName + "/" + sound);
                settings->setValue("Sounds/" +main_name+"/"+ name + "/" + sound, soundDetails);
            }

            // Remove old category key
            settings->remove("Sounds/"+main_name+"/"+ oldName);

            // Update category name in the list
            categories[index] = name;
            QString category = QString("Categories/%1").arg(main_name);
            scheduleSettingSave(category, categories);

            // Rename the category section
            settings->beginGroup("Sounds");
            settings->remove(oldName);
            settings->endGroup();
            settings->beginGroup("Sounds");
            settings->setValue(name, sounds);
            settings->endGroup();

            return 0; // Success
        } else {
            return 3; // Old category not found
        }
    }

    return 4; // Invalid mode
}


void SettingsManager::deleteCategory(const QString &name)
{
    QStringList categories = getCategories();
    if (categories.removeOne(name)) {
        scheduleSettingSave("Categories/Categories", categories);
        settings->remove("Sounds/" + name);
        settings->remove("Categories/" + name+"_level");
    }
}
void SettingsManager::deleteMainCategory(const QString &main_name)
{
    QStringList subCategories = getSubCategories(main_name);
    for (const QString& name : subCategories) {
        settings->remove("Sounds/"+main_name+"/"+name);
    }
    QStringList categories = getCategories();
    if (categories.removeOne(main_name)) {
        QString category_mode = QString("Categories/%1_isMain").arg(main_name);
        QString mainCategory = QString("Categories/%1").arg(main_name);
        QString mainCategory_level = QString("Categories/%1_level").arg(main_name);
        settings->remove(category_mode);
        settings->remove(mainCategory);
        settings->remove(mainCategory_level);
        scheduleSettingSave("Categories/Categories", categories);
    }


}
void SettingsManager::deleteSubCategory(const QString &main_name,const QString &name)
{
    QStringList categories = getSubCategories(main_name);
    if (categories.removeOne(name)) {
        QString category = QString("Categories/%1").arg(main_name);

        scheduleSettingSave(category, categories);
        settings->remove("Sounds/"+main_name+"/"+name);
    }
}
bool SettingsManager::isMainCategory(const QString &name){
    QString key = QString("Categories/%1_isMain").arg(name);
    return settings->value(key, false).toBool();
}
int SettingsManager::getCategoryLevel(const QString &name){
    return settings->value(QString("Categories/%1_level").arg(name), 0).toInt();
}
QStringList SettingsManager::getSoundsForCategory(const QString &category) const {
    return settings->value("Sounds/" + category).toStringList();
}
QStringList SettingsManager::getSoundsForSubCategory(const QString &main_name ,const QString &category) const {
    return settings->value("Sounds/"+main_name+"/"+ category).toStringList();
}
int SettingsManager::saveSound(const QString &category, const QString &name, int msb, int lsb, int pc) {
    QStringList sounds = getSoundsForCategory(category);
    QVariantMap soundDetails;
    soundDetails["msb"] = msb;
    soundDetails["lsb"] = lsb;
    soundDetails["pc"] = pc;

    if (!sounds.contains(name)) {
        sounds.append(name);
        settings->setValue("Sounds/" + category, sounds);
    }
    settings->setValue("Sounds/" + category + "/" + name, soundDetails);
    return 0; // Success
}
int SettingsManager::saveSubSound(const QString &main_name,const QString &category, const QString &name, int msb, int lsb, int pc) {
    QStringList sounds = getSoundsForSubCategory(main_name,category);
    QVariantMap soundDetails;
    soundDetails["msb"] = msb;
    soundDetails["lsb"] = lsb;
    soundDetails["pc"] = pc;

    if (!sounds.contains(name)) {
        sounds.append(name);
        settings->setValue("Sounds/" +main_name+"/" + category, sounds);
    }
    settings->setValue("Sounds/" +main_name+"/" + category + "/" + name, soundDetails);
    return 0; // Success
}

bool SettingsManager::deleteSound(const QString &category, const QString &name) {
    QStringList sounds = getSoundsForCategory(category);
    if (sounds.removeOne(name)) {
        settings->setValue("Sounds/" + category, sounds);
        settings->remove("Sounds/" + category + "/" + name);
        return true;
    }
    return false;
}
bool SettingsManager::deleteSubSound(const QString &main_name,const QString &category, const QString &name) {
    QStringList sounds = getSoundsForSubCategory(main_name,category);
    if (sounds.removeOne(name)) {
        settings->setValue("Sounds/"  +main_name+"/"+ category, sounds);
        settings->remove("Sounds/"  +main_name+"/"+ category + "/" + name);
        return true;
    }
    return false;
}
QVariantMap SettingsManager::getSoundDetails(const QString &category, const QString &name) const {
    QVariantMap soundDetails = settings->value("Sounds/" + category + "/" + name).toMap();
    if (soundDetails.isEmpty()) {
        qWarning() << "Sound details not found for category" << category << "and name" << name;
    }
    if (!soundDetails.contains("name")) {
        soundDetails["name"] = name;
    }
    return soundDetails;
}
QVariantMap SettingsManager::getSoundSubDetails(const QString &main_name,const QString &category, const QString &name) const {
    QVariantMap soundDetails = settings->value("Sounds/"+main_name+"/"+ category + "/" + name).toMap();
    if (soundDetails.isEmpty()) {
        qWarning() << "Sound details not found for category" << category << "and name" << name;
    }
    if (!soundDetails.contains("name")) {
        soundDetails["name"] = name;
    }
    return soundDetails;
}


void  SettingsManager::saveRawOutputCCEnabled(const QString &cc_id, bool enabled){
    QString key = QString("RawOutputSettings/CC_%1").arg(cc_id);
    scheduleSettingSave(key, enabled);
}
void  SettingsManager::saveRawOutputPCEnabled(const QString &pc_id, bool enabled){
    QString key = QString("RawOutputSettings/PC_%1").arg(pc_id);
    scheduleSettingSave(key, enabled);
}

bool SettingsManager::getRawOutputCCEnabled(const QString &cc_id) const{
    QString key = QString("RawOutputSettings/CC_%1").arg(cc_id);
    return settings->value(key, false).toBool();
}

bool SettingsManager::getRawOutputPCEnabled(const QString &pc_id) const{
    QString key = QString("RawOutputSettings/PC_%1").arg(pc_id);
    return settings->value(key, false).toBool();
}

int SettingsManager::getRawOutputChannel(int port) const
{
    return settings->value(QString("RawOutputSettings/channel_%1").arg(port), 0).toInt();
}

void SettingsManager::saveRawOutputChannel(int port,int channel)
{
    scheduleSettingSave(QString("RawOutputSettings/channel_%1").arg(port), channel);
}


bool SettingsManager::importSounds(const QString &category, const QString &fileContent)
{
    QStringList lines = fileContent.split('\n', Qt::SkipEmptyParts);
    bool success = true;

    for (const QString &line : lines) {
        QStringList parts = line.split(' ');
        if (parts.size() >= 4) {
            QString name = parts.mid(0, parts.size() - 3).join(' ').trimmed();
            int msb = parts[parts.size() - 3].toInt();
            int lsb = parts[parts.size() - 2].toInt();
            int pc = parts[parts.size() - 1].toInt();

            if (saveSound(category, name, msb, lsb, pc) != 0) {
                success = false;
            }
        } else {
            success = false;
        }
    }

    return success;
}

bool SettingsManager::importSubSounds(const QString &main_name,const QString &category, const QString &fileContent)
{
    QStringList lines = fileContent.split('\n', Qt::SkipEmptyParts);
    bool success = true;

    for (const QString &line : lines) {
        QStringList parts = line.split(' ');
        if (parts.size() >= 4) {
            QString name = parts.mid(0, parts.size() - 3).join(' ').trimmed();
            int msb = parts[parts.size() - 3].toInt();
            int lsb = parts[parts.size() - 2].toInt();
            int pc = parts[parts.size() - 1].toInt();

            if (saveSubSound(main_name,category, name, msb, lsb, pc) != 0) {
                success = false;
            }
        } else {
            success = false;
        }
    }

    return success;
}
QString SettingsManager::exportSounds(const QString &category) const
{
    QStringList sounds = getSoundsForCategory(category);
    QStringList exportLines;

    for (const QString &sound : sounds) {
        QVariantMap details = getSoundDetails(category, sound);
        if (details.contains("name") && details.contains("msb") && details.contains("lsb") && details.contains("pc")) {
            QString line = QString("%1 %2 %3 %4")
                               .arg(details["name"].toString())
                               .arg(details["msb"].toInt())
                               .arg(details["lsb"].toInt())
                               .arg(details["pc"].toInt());
            exportLines.append(line);
        }
    }

    return exportLines.join("\n");
}
QString SettingsManager::exportSubSounds(const QString &main_name ,const QString &category) const
{
    QStringList sounds = getSoundsForSubCategory(main_name,category);
    QStringList exportLines;

    for (const QString &sound : sounds) {
        QVariantMap details = getSoundSubDetails(main_name,category, sound);
        if (details.contains("name") && details.contains("msb") && details.contains("lsb") && details.contains("pc")) {
            QString line = QString("%1 %2 %3 %4")
                               .arg(details["name"].toString())
                               .arg(details["msb"].toInt())
                               .arg(details["lsb"].toInt())
                               .arg(details["pc"].toInt());
            exportLines.append(line);
        }
    }

    return exportLines.join("\n");
}
bool SettingsManager::saveSoundsToFile(const QString &filePath, const QString &content) {
    const QUrl url(filePath);
    QString localFilePath;
    if (url.isLocalFile()) {
        localFilePath = url.toLocalFile();
    } else {
        localFilePath=filePath;
    }

    QFile file(localFilePath);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return false;
    }
    QTextStream out(&file);
    out << content;
    file.close();
    return true;
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
    emit categoriesLoaded();
    pendingSettings.clear();
}
