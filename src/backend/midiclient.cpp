#include "midiclient.h"

MidiClient::MidiClient(QObject *parent)
    : QObject(parent) {
    jackClient = new JackClient;
    connect(jackClient, &JackClient::midiMessageReceived, this, &MidiClient::handleMidiMessage);
    m_inputPorts = new MidiPortModel(this);
    m_outputPorts = new MidiPortModel(this);
    getIOPorts();

}
void MidiClient::handleMidiMessage(const libremidi::message& message)
{
    // Handle the received MIDI message here
    // e.g., update UI, process the message, etc.
    qDebug()<< message;
    if (itsNote(message)) {
        // Get the list of enabled channels
        QList<int> enabledChannels =   {};
        QList<int> enabledChannels_lower =   {};

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
        if(channel==0){
            qDebug()<<"CHHHHHHHHHHH 1 " <<channel;
            for (int ch : enabledChannels) {
                sendNoteOn(ch, note, velocity);

            }
        }
        else if(channel==1){
            qDebug()<<"CHHHHHHHHHHH 2 " <<channel;
            for (int ch : enabledChannels_lower) {
                sendNoteOn(ch, note, velocity);

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
    libremidi::message channelMessage = libremidi::channel_events::note_on(channel, note, velocity);
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
    qDebug()<<"Channel : "<<channel+1<< volume;
    // Send a Control Change message for CC #7 (Volume)
    jackClient->sendMidiMessage(0, libremidi::channel_events::control_change(channel+1, 0x07, volume));
}
void MidiClient::sendAllNotesOff(int channel)
{
    // Send the "All Notes Off" message for the specified channel
    jackClient->sendMidiMessage(0, libremidi::channel_events::control_change(channel+1, 123, 0));
    qDebug()<<"sendAllNotesOff Channel : "<<channel+1;
}
void MidiClient::getIOPorts(){

    if (jackClient->observer.has_value()) { // Check if optional has a value
        m_inputPorts->clear();
        libremidi::observer& obs = jackClient->observer.value(); // Dereference optional to get the underlying libremidi::observer object
        for(const libremidi::input_port& port : obs.get_input_ports()) {
            qDebug()<< port.port_name;
            //   jackClient->midiin->open_port(port,"In");
            m_inputPorts->addPort(QString::fromStdString(port.port_name), QVariant::fromValue(port));
        }
    }
    if (jackClient->observer.has_value()) { // Check if optional has a value
        m_outputPorts->clear();
        libremidi::observer& obs = jackClient->observer.value(); // Dereference optional to get the underlying libremidi::observer object
        for(const libremidi::output_port& port : obs.get_output_ports()) {
            qDebug()<< port.port_name;
            m_outputPorts->addPort(QString::fromStdString(port.port_name), QVariant::fromValue(port));
            //   jackClient->midiout->open_port(port,"Out");

        }
    }
}
