#include "midiclient.h"

MidiClient::MidiClient(QObject *parent)
    : QObject(parent), m_bankNumber(0)  {
    jackClient = new JackClient;
    connect(jackClient, &JackClient::midiMessageReceived, this, &MidiClient::handleMidiMessage);
    m_inputPorts = new MidiPortModel(this);
    m_outputPorts = new MidiPortModel(this);
    jackClient->midiout_raw->open_virtual_port("Raw Out");
    getIOPorts();
    QTimer *connectionCheckTimer = new QTimer(this);
    connect(connectionCheckTimer, &QTimer::timeout, this, &MidiClient::checkOutputPortConnection);
    connectionCheckTimer->start(1000); // Check every second

}
void MidiClient::handleMidiMessage(const libremidi::message& message)
{
    // Handle the received MIDI message here
    // e.g., update UI, process the message, etc.
    qDebug()<< message;
    int bankNumber = 0;
    if (isGenosRegistrationBankChange(message, bankNumber)) {
        qDebug() << "Received registration bank change for bank" << bankNumber;
        setBankNumber(bankNumber);
    }

    if(itsVolumeCC(message))
    {
        int statusByte = message[0];
        int channel = statusByte & 0x0F; // Mask the lowest 4 bits
        int midivolume=message[2];
        int volume=( midivolume * 100) / 127;
        if(channel==15){
            setMasterVolume(volume);
            qDebug()<<"SEND MIDI VOLUME "<<volume;
        }
    }
    if(!itsVolumeCC(message)){
        jackClient->midiout_raw->send_message(message);
    }
    if (itsNote(message)) {


        // Extract the note and velocity from the message
        int note = message[1];
        int velocity = message[2];
        // Check if the message is a note-off
        int statusByte = message[0];
        int channel = statusByte & 0x0F; // Mask the lowest 4 bits
        int messageType = statusByte & 0xF0; // Mask the highest 4 bits
        if (messageType == 0x80) {
            // It's a note-off message, send note-off with velocity 0
            velocity = 0;
        }
        // Handle note capture for range setting
        if (m_capturingLowNote) {
            m_lowNote = note;
            setCapturingLowNote(false);
            setChannelRange(m_currentChannel, m_lowNote, m_highNote);
            //   updateNoteRange();
            return; // Exit after capturing low note
        } else if (m_capturingHighNote) {
            m_highNote = note;
            setCapturingHighNote(false);
            setChannelRange(m_currentChannel, m_lowNote, m_highNote);
            //   updateNoteRange();
            return; // Exit after capturing high note
        }

        if(channel == 0){
            emit channelActivated(0);
            for (int ly : m_enabledLayersUpper) {
                sendNoteOn(ly, note, velocity);
                //   qDebug() << "Upper Channel";
            }
        }
        else if(channel == 1){

            emit channelActivated(1);
            for (int ly : m_enabledLayersLower) {
                sendNoteOn(ly, note, velocity);
                //  qDebug() << "Lower Channel";
            }
        }
        else if(channel == 2){

            emit channelActivated(2);
            for (int ly : m_enabledLayersPedal) {
                sendNoteOn(ly, note, velocity);
                //  qDebug() << "Pedal Channel";
            }
        }
    }
}
bool MidiClient::itsNote(const libremidi::message& message)
{
    if (!message.empty()) {
        int statusByte = message[0];
        int messageType = statusByte & 0xF0; // Mask the highest 4 bits

        // Check if the message is a Note On or Note Off
        return (messageType == 0x80 || messageType == 0x90);
    }

    return false;
}
void MidiClient::sendNoteOn(int channel, int note, int velocity)
{
    qDebug() << " CHANNEL : "<<channel << "NOTE : "   << note  <<"VELOCITY : " <<velocity;
    if (!isNoteInRange(channel, note)) {
        qDebug() << "Note" << note << "is out of range for channel" << channel << ". Skipping.";
        return;
    }
    int adjustedNote = setNoteOctave(channel,note);
    qDebug() << " CHANNEL : "<<channel << "NOTE adjustedNote  : "   << adjustedNote  <<"VELOCITY : " <<velocity;
    libremidi::message channelMessage = libremidi::channel_events::note_on(channel+1, adjustedNote, velocity);
    jackClient->sendMidiMessage(0, channelMessage);
}
void MidiClient::sendControlChange(int channel, int control, int value)
{
    jackClient->sendMidiMessage(0, libremidi::channel_events::control_change(channel, control, value));
}

void MidiClient::sendPitchBend(int channel, int value)
{
    jackClient->sendMidiMessage(0, libremidi::channel_events::pitch_bend(channel, value));
}
void MidiClient::sendRawMessage(const libremidi::message& message)
{
    jackClient->sendMidiMessage(0, message);
}
void MidiClient::setVolume(int channel, int volume)
{
    // Ensure the channel is in the valid range (0-15)
    if (channel < 0 || (channel > 15))
        return;

    // Map the volume from the range 0-99 to the MIDI range 0-127
    volume = qBound(0, (volume * 127) / 99, 127);
    //qDebug()<<"Channel : "<<channel+1<< volume;
    // Send a Control Change message for CC #7 (Volume)
    jackClient->sendMidiMessage(0, libremidi::channel_events::control_change(channel+1, 0x07, volume));
    if(cc()){
        if(m_rowoutputchannel==17){
            for(int i=1;i<=16;i++){
                jackClient->midiout_raw->send_message(libremidi::channel_events::control_change(i, 0x07, volume));
            }
        }
        else
            jackClient->midiout_raw->send_message(libremidi::channel_events::control_change(m_rowoutputchannel, 0x07, volume));

    }
}
void MidiClient::setReverb(int channel, int reverb)
{
    // Ensure the channel is in the valid range (0-15)
    if (channel < 0 || (channel > 15))
        return;
    // Map the reverb from the range 0-99 to the MIDI range 0-127
    reverb = qBound(0, (reverb * 127) / 99, 127);
    //qDebug()<<"Channel : "<<channel+1<< reverb;
    // Send a Control Change message for CC #91 (reverb)
    jackClient->sendMidiMessage(0, libremidi::channel_events::control_change(channel+1, 0x5B, reverb));
}
void MidiClient::sendAllNotesOff()
{
    // Send the "All Notes Off" message for the specified channel
    for(int i=1;i<=16;i++){
        jackClient->sendMidiMessage(0, libremidi::channel_events::control_change(i, 123, 0));
        jackClient->midiout_raw->send_message(libremidi::channel_events::control_change(i, 123, 0));
    }
}
void MidiClient::sendNotesOff(int channel)
{
    // Send the "Notes Off" message for the specified channel
    jackClient->sendMidiMessage(0, libremidi::channel_events::control_change(channel+1, 123, 0));
}
void MidiClient::sendMsbLsbPc(int channel, int msb, int lsb, int pc)
{
    // Ensure the channel is in the valid range (1-16 in MIDI, but 0-15 in some APIs)
    if (channel < 0 || (channel > 15))
        return;

    // Ensure MSB, LSB, and PC values are in the valid MIDI range (0-127)
    msb = qBound(0, msb, 127);
    lsb = qBound(0, lsb, 127);
    pc = qBound(0, pc, 127);


    // Send the MSB, LSB, and PC messages
    jackClient->sendMidiMessage(0, libremidi::channel_events::control_change(channel+1, 0x00, msb));  // MSB (0x00)
    jackClient->sendMidiMessage(0, libremidi::channel_events::control_change(channel+1, 0x20, lsb));  // LSB (0x20)
    jackClient->sendMidiMessage(0, libremidi::channel_events::program_change(channel+1, pc));         // PC
    qDebug() << "Sent MSB:" << msb << "LSB:" << lsb << "PC:" << pc<< "on channel:" << channel;
}

void MidiClient::getIOPorts(){

    if (jackClient->observer.has_value()) { // Check if optional has a value
        m_inputPorts->clear();
        libremidi::observer& obs = jackClient->observer.value(); // Dereference optional to get the underlying libremidi::observer object
        for(const libremidi::input_port& port : obs.get_input_ports()) {
            //qDebug()<< port.port_name;
            //   jackClient->midiin->open_port(port,"In");
            m_inputPorts->addPort(QString::fromStdString(port.port_name), QVariant::fromValue(port));
        }
    }
    if (jackClient->observer.has_value()) { // Check if optional has a value
        m_outputPorts->clear();
        libremidi::observer& obs = jackClient->observer.value(); // Dereference optional to get the underlying libremidi::observer object
        for(const libremidi::output_port& port : obs.get_output_ports()) {
            //  qDebug()<< port.port_name;
            m_outputPorts->addPort(QString::fromStdString(port.port_name), QVariant::fromValue(port));
            //   jackClient->midiout->open_port(port,"Out");

        }
    }
}

void MidiClient::makeConnection(QVariant inputPorts,QVariant outputPorts){

    if (inputPorts.isValid()) {
        jackClient->midiin->close_port();
        libremidi::input_port selectedInputPort = qvariant_cast<libremidi::input_port>(inputPorts);
        jackClient->midiin->open_port(selectedInputPort,"In");
    }
    else {
        // Handle case when no port is selected
        qDebug() << "No input port selected.";
    }
    // Use the selected ports as needed
    if (outputPorts.isValid()) {
        jackClient->midiout->close_port();
        libremidi::output_port selectedOutputPort = qvariant_cast<libremidi::output_port>(outputPorts);
        jackClient->midiout->open_port(selectedOutputPort,"Out");
    }
    else {
        // Handle case when no port is selected
        qDebug() << "No output port selected.";
    }

    emit outputPortConnectionChanged();
}

void MidiClient::makeDisconnect(){
    jackClient->midiin->close_port();
    jackClient->midiout->close_port();

    // Handle case when no port is selected
    emit outputPortConnectionChanged();
    qDebug() << "Disconnected";

}
void MidiClient::checkOutputPortConnection(){
    bool currentStatus = isOutputPortConnected();
    if (currentStatus != m_lastOutputPortStatus) {
        m_lastOutputPortStatus = currentStatus;
        emit outputPortConnectionChanged();
    }
}
void MidiClient::setLayerEnabled(LayersSet set, int layer, bool enabled)
{
    QList<int>* targetList;
    switch(set) {
    case Upper: targetList = &m_enabledLayersUpper; break;
    case Lower: targetList = &m_enabledLayersLower; break;
    case Pedal: targetList = &m_enabledLayersPedal; break;
    }

    if (enabled && !targetList->contains(layer)) {
        targetList->append(layer);
    } else if (!enabled) {
        targetList->removeAll(layer);
    }
}
void MidiClient::setCc(bool cc) {
    if (m_cc != cc) {
        m_cc = cc;
        emit ccChanged();
    }
}
void MidiClient::setPc(bool pc) {
    if (m_pc != pc) {
        m_pc = pc;
        emit pcChanged();
    }
}
bool MidiClient::cc() const {
    return m_cc;
}
bool MidiClient::pc() const {
    return m_pc;
}

int MidiClient::rowOutputChannel() const {
    return m_rowoutputchannel;
}

void MidiClient::setRowOutputChannel(int channel) {
    if (m_rowoutputchannel != channel) {
        m_rowoutputchannel = channel;
        emit rowOutputChannelChanged();
    }
}
void MidiClient::setMasterVolume(int volume){
    float mappedVolume = volume / 100.0f;
    jackClient->setVolume(mappedVolume);
    emit masterVolumeChanged();
}
int MidiClient::masterVolume(){
    float volume = jackClient->volume();
    int intVolume = static_cast<int>(volume * 100.0f);
    return intVolume;
}
bool MidiClient::itsVolumeCC(const libremidi::message& message)
{
    if (!message.empty()) {
        int statusByte = message[0];
        int messageType = statusByte & 0xF0; // Mask the highest 4 bits

        // Check if the message is a Control Change (CC) message
        if (messageType == 0xB0 && message.size() > 1) {
            int controlNumber = message[1]; // The second byte is the control number

            // Check if the control number is 7 (which is the standard for volume)
            return (controlNumber == 7);
        }
    }

    return false;
}


int MidiClient::octave(int channel) const
{
    return m_octaves.value(channel, 0);
}

void MidiClient::setOctave(int channel, int octave)
{
    if (m_octaves.value(channel, 0) != octave) {
        m_octaves[channel] = octave;
        emit octavesChanged();
    }
}
QMap<int, int> MidiClient::octaves() const
{
    return m_octaves;
}
int MidiClient::setNoteOctave(int channel, int note){
    int octave = this->octave(channel);

    // Calculate the adjustment
    int adjustment = octave * 12;

    // Apply the adjustment to the note
    int adjustedNote = note + adjustment;

    // Return the adjusted note
    return adjustedNote;

}

void MidiClient::setChannelRange(int channel, int lowNote, int highNote)
{
    // Ensure the notes are within the valid MIDI range (0-127)
    lowNote = qBound(0, lowNote, 127);
    highNote = qBound(0, highNote, 127);
    // Ensure lowNote is not greater than highNote
    if (lowNote > highNote) {
        qSwap(lowNote, highNote);
    }

    m_channelRanges[channel] = qMakePair(lowNote, highNote);
    m_lowNote = lowNote;
    m_highNote = highNote;
    updateNoteRange();
}

bool MidiClient::isNoteInRange(int channel, int note)
{
    if (!m_channelRanges.contains(channel)) {
        return true;  // If no range set for this channel, allow all notes
    }

    QPair<int, int> range = m_channelRanges[channel];
    return note >= range.first && note <= range.second;
}

void MidiClient::updateNoteRange()
{
    // if (m_lowNote != -1 && m_highNote != -1) {
    //     m_noteRange = QString("%1-%2").arg(m_lowNote).arg(m_highNote);
    //     emit noteRangeChanged();
    // }
    if (m_lowNote != -1 && m_highNote != -1) {
        QString lowNoteName = noteNumberToName(m_lowNote);
        QString highNoteName = noteNumberToName(m_highNote);
        m_noteRange = QString("%1-%2").arg(lowNoteName).arg(highNoteName);
        emit noteRangeChanged();
    }
}
void MidiClient::setCapturingLowNote(bool capturing)
{
    if (m_capturingLowNote != capturing) {
        m_capturingLowNote = capturing;
        if (capturing) {
            m_capturingHighNote = false;
            emit capturingHighNoteChanged();
        }
        emit capturingLowNoteChanged();
    }
}

void MidiClient::setCapturingHighNote(bool capturing)
{
    if (m_capturingHighNote != capturing) {
        m_capturingHighNote = capturing;
        if (capturing) {
            m_capturingLowNote = false;
            emit capturingLowNoteChanged();
        }
        emit capturingHighNoteChanged();
    }
}
void MidiClient::setCurrentChannel(int channel){
    if (m_currentChannel != channel) {
        setCapturingLowNote(false);
        setCapturingHighNote(false);
        m_currentChannel = channel;
        emit currentChannelChanged();
    }
}

QVariantMap MidiClient::channelRanges() const
{
    QVariantMap result;
    for (auto it = m_channelRanges.cbegin(); it != m_channelRanges.cend(); ++it) {
        QVariantMap range;
        range["lowNote"] = it.value().first;
        range["highNote"] = it.value().second;
        result[QString::number(it.key())] = range;
    }
    return result;
}
QString MidiClient::noteNumberToName(int noteNumber) const
{
    if (noteNumber < 0 || noteNumber > 127) {
        return "Invalid"; // Handle out of range notes
    }

    const QStringList noteNames = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
    int octave = noteNumber / 12 - 1;
    QString note = noteNames[noteNumber % 12];

    return QString("%1%2").arg(note).arg(octave);
}
void MidiClient::sendRegistrationChange(int bankNumber)
{


    // Ensure bankNumber is within the range 1-10
    if (bankNumber < 1 || bankNumber > 10) {
        qWarning() << "Invalid bank number. Please use a value between 1 and 10.";
        return;
    }

    // Create a libremidi::message directly using initializer list
    libremidi::message message{
        240, 67, 115, 1, 82, 37, 17, 0, 2, 0, static_cast<unsigned char>(bankNumber - 1), 247
    };

    // Send the SysEx message
    jackClient->send_MidiMessage(message);
}

bool MidiClient::isGenosRegistrationBankChange(const libremidi::message& message, int& bankNumber)
{
    // Check if the message is a SysEx message
    if (message[0] != 0xF0 || message.back() != 0xF7) {
        return false; // Not a SysEx message
    }

    // Check if the message is a Yamaha Genos registration bank change
    // SysEx message structure: 240, 67, 115, 1, 82, 37, 17, 0, 2, 0, <bank>, 247
    if (message.size() == 12 &&
        message[1] == 67 &&  // Yamaha Manufacturer ID
        message[2] == 115 && // Extended ID
        message[3] == 1 &&   // Device ID (can vary)
        message[4] == 82 &&  // Command ID
        message[5] == 37 &&  // Sub-command
        message[6] == 17 &&  // Indicates registration memory change
        message[7] == 0 &&
        message[8] == 2 &&
        message[9] == 0)
    {
        // Extract the bank number from the second-to-last byte
        bankNumber = message[10] + 1; // Adjust to 1-based index for banks 1-10
        return true;
    }

    return false; // Not a registration bank change message
}
int MidiClient::bankNumber() const
{
    return m_bankNumber;
}

void MidiClient::setBankNumber(int newBankNumber)
{
    if (m_bankNumber != newBankNumber) {
        m_bankNumber = newBankNumber;
        emit bankNumberChanged(m_bankNumber);  // Emit signal when the bankNumber changes
    }
}
