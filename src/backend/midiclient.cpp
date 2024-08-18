#include "midiclient.h"

MidiClient::MidiClient(QObject *parent)
    : QObject(parent) {
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
    jackClient->midiout_raw->send_message(message);
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
        // Send the note-off message to all enabled channels
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
        // if(channel==0){
        //     qDebug()<<"CHHHHHHHHHHH 1 " <<channel;
        //      emit channelActivated(0);
        //     for (int ch : enabledChannels) {
        //         sendNoteOn(ch, note, velocity);


        //     }
        // }
        // else if(channel==1){
        //     qDebug()<<"CHHHHHHHHHHH 2 " <<channel;
        //           emit channelActivated(1);
        //     for (int ch : enabledChannels_lower) {
        //         sendNoteOn(ch, note, velocity);


        //     }
        // }

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
    // qDebug() << " Layer : "<<channel;
    libremidi::message channelMessage = libremidi::channel_events::note_on(channel+1, note, velocity);
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
    }
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
    // qDebug() << "Sent MSB:" << msb << "LSB:" << lsb << "PC:" << pc << "on channel:" << channel;
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
