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
    qDebug()<<"C++ saveCategory";
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
    qDebug()<<"C++ saveSubCategory";
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
            settings->setValue(main_name+"/"+name, sounds);
            settings->endGroup();

            return 0; // Success
        } else {
            return 3; // Old category not found
        }
    }

    return 4; // Invalid mode
}
int SettingsManager::renameMainCategory(const QString &oldName, const QString &newName) {

    // Check if the new name already exists
    QStringList categories = getCategories();
    if (categories.contains(newName)) {
        return 1; // New category name already exists
    }

    // Rename main category
    int index = categories.indexOf(oldName);
    if (index == -1) {
        return 2; // Old category not found
    }
    categories[index] = newName;
    scheduleSettingSave("Categories/Categories", categories);

    // Update isMain and level settings
    QString oldModeKey = QString("Categories/%1_isMain").arg(oldName);
    QString newModeKey = QString("Categories/%1_isMain").arg(newName);
    QString oldLevelKey = QString("Categories/%1_level").arg(oldName);
    QString newLevelKey = QString("Categories/%1_level").arg(newName);

    QVariant isMain = settings->value(oldModeKey);
    QVariant level = settings->value(oldLevelKey);

    scheduleSettingSave(newModeKey, isMain);
    scheduleSettingSave(newLevelKey, level);

    settings->remove(oldModeKey);
    settings->remove(oldLevelKey);

    // Move subcategories to new main category
    QStringList subCategories = getSubCategories(oldName);
    QString oldSubCategoryKey = QString("Categories/%1").arg(oldName);
    QString newSubCategoryKey = QString("Categories/%1").arg(newName);
    scheduleSettingSave(newSubCategoryKey, subCategories);
    settings->remove(oldSubCategoryKey);

    // Update sounds
    for (const QString &subCategory : subCategories) {
        QStringList sounds = getSoundsForSubCategory(oldName, subCategory);
        for (const QString &sound : sounds) {
            QVariantMap soundDetails = getSoundSubDetails(oldName, subCategory, sound);
            settings->remove("Sounds/" + oldName + "/" + subCategory + "/" + sound);
            settings->setValue("Sounds/" + newName + "/" + subCategory + "/" + sound, soundDetails);
        }
        // Remove old subcategory key
        settings->remove("Sounds/" + oldName + "/" + subCategory);
        // Update subcategory in the new main category
        settings->setValue("Sounds/" + newName + "/" + subCategory, sounds);
    }

    // Remove old main category key
    settings->remove("Sounds/" + oldName);

    return 0; // Success
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

SettingsManager::SoundOperationResult SettingsManager::copySoundBetweenCategories(const QString &sourceCategory, const QString &destCategory, const QString &soundName){

    // Check if the sound exists in the source category and get its details
    QVariantMap soundDetails = getSoundDetails(sourceCategory, soundName);
    if (soundDetails.isEmpty()) {
        return {1, ""}; // Sound not found in source category
    }

    // Check if the sound already exists in the destination category
    QStringList destSounds = getSoundsForCategory(destCategory);
    QString finalSoundName = soundName;

    if (destSounds.contains(soundName)) {
        finalSoundName = generateUniqueSoundName(destCategory, soundName);
    }

    // Copy the sound to the destination category with the final name
    settings->setValue("Sounds/" + destCategory + "/" + finalSoundName, soundDetails);

    // Update the sound list for the destination category
    destSounds.append(finalSoundName);
    settings->setValue("Sounds/" + destCategory, destSounds);

    return {0, finalSoundName}; // Success
}

SettingsManager::SoundOperationResult SettingsManager::cutSoundBetweenCategories(const QString &sourceCategory, const QString &destCategory, const QString &soundName){
    // First, copy the sound to the destination category
    SoundOperationResult copyResult = copySoundBetweenCategories(sourceCategory, destCategory, soundName);

    if (copyResult.status == 0) {
        // Remove the original sound from the source category
        deleteSound(sourceCategory, soundName);

        return copyResult; // Return the result of the copy operation
    }

    return copyResult; // If copy failed, return its result


}

QString SettingsManager::generateUniqueSoundName(const QString &category, const QString &originalName){
    QString baseName = originalName;
    QString newName = baseName;
    int counter = 1;
    QStringList existingSounds = getSoundsForCategory(category);

    while (existingSounds.contains(newName)) {
        newName = QString("%1_%2").arg(baseName).arg(counter);
        counter++;
    }

    return newName;

}

SettingsManager::SoundOperationResult SettingsManager::copySoundBetweenSubCategories(const QString &sourceCat, const QString &sourceSubCat,
                                                                                     const QString &destCat, const QString &destSubCat,
                                                                                     const QString &soundName) {
    // Check if the sound exists in the source subcategory
    QVariantMap soundDetails = getSoundSubDetails(sourceCat, sourceSubCat, soundName);
    if (soundDetails.isEmpty()) {
        return {1, ""}; // Sound not found in source subcategory
    }

    // Check if the sound already exists in the destination subcategory
    QStringList destSounds = getSoundsForSubCategory(destCat, destSubCat);
    QString finalSoundName = soundName;

    if (destSounds.contains(soundName)) {
        // Generate a unique name if the sound already exists
        finalSoundName = generateUniqueSoundNameForSubCategory(destCat, destSubCat, soundName);
    }

    // Copy the sound to the destination subcategory with the final name
    QString destKey = QString("Sounds/%1/%2/%3").arg(destCat, destSubCat, finalSoundName);
    settings->setValue(destKey, soundDetails);

    // Update the sound list for the destination subcategory
    destSounds.append(finalSoundName);
    settings->setValue(QString("Sounds/%1/%2").arg(destCat, destSubCat), destSounds);

    return {0, finalSoundName}; // Success
}

SettingsManager::SoundOperationResult SettingsManager::cutSoundBetweenSubCategories(const QString &sourceCat, const QString &sourceSubCat,
                                                                                    const QString &destCat, const QString &destSubCat,
                                                                                    const QString &soundName) {
    // First, copy the sound to the destination subcategory
    SoundOperationResult copyResult = copySoundBetweenSubCategories(sourceCat, sourceSubCat, destCat, destSubCat, soundName);

    if (copyResult.status == 0) {
        // Remove the original sound from the source subcategory
        deleteSubSound(sourceCat, sourceSubCat, soundName);

        return copyResult; // Return the result of the copy operation
    }

    return copyResult; // If copy failed, return its result
}

QString SettingsManager::generateUniqueSoundNameForSubCategory(const QString &category, const QString &subCategory, const QString &originalName) {
    QString baseName = originalName;
    QString newName = baseName;
    int counter = 1;
    QStringList existingSounds = getSoundsForSubCategory(category, subCategory);

    while (existingSounds.contains(newName)) {
        newName = QString("%1_%2").arg(baseName).arg(counter);
        counter++;
    }

    return newName;
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
void SettingsManager::saveChannelSound(int channel, bool chIsInMain, const QString &chMainCategory, int chCategoryIndex, int chSoundIndex)
{
    QString key = QString("ChannelSounds/Channel_%1").arg(channel);
    QVariantMap channelData;
    channelData["isInMain"] = chIsInMain;
    channelData["mainCategory"] = chMainCategory;
    channelData["categoryIndex"] = chCategoryIndex;
    channelData["soundIndex"] = chSoundIndex;

    scheduleSettingSave(key, channelData);
}

void SettingsManager::saveOctave(int channel, int octave){
    QString key = QString("ChannelOctave/Channel_%1").arg(channel);
    scheduleSettingSave(key, octave);
}
int SettingsManager::getOctave(int channel) const
{
    QString key = QString("ChannelOctave/Channel_%1").arg(channel);
    return settings->value(key, 0).toInt();
}

QVariantMap SettingsManager::getChannelSound(int channel) const
{
    QString key = QString("ChannelSounds/Channel_%1").arg(channel);
    return settings->value(key).toMap();
}

void SettingsManager::saveChannelRange(int channel, int lowNote, int highNote)
{
    QString key = QString("ChannelRange/Channel_%1").arg(channel);
    QString value = QString("%1,%2").arg(lowNote).arg(highNote);
    scheduleSettingSave(key, value);
}

QVariantMap SettingsManager::getChannelRange(int channel) const
{
    QString key = QString("ChannelRange/Channel_%1").arg(channel);
    QString value = settings->value(key, "0,127").toString(); // Default range 0 to 127
    QStringList range = value.split(",");

    QVariantMap result;
    if (range.size() == 2) {
        result["lowNote"] = range[0].toInt();
        result["highNote"] = range[1].toInt();
    } else {
        result["lowNote"] = 0;
        result["highNote"] = 127; // Default range if parsing fails
    }
    return  result;
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
