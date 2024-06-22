#ifndef MIDICLIENT_H
#define MIDICLIENT_H

#include <QObject>
#include <backend/jackclient.h>
#include <backend/midiutils.h>

class MidiClient  : public QObject
{
        Q_OBJECT  // Add this macro
public:
   explicit MidiClient(QObject *parent = nullptr);
public slots:
    void sendNoteOn(int channel, int note, int velocity);
    void sendControlChange(int channel, int control, int value);
    void sendPitchBend(int channel, int value);
    void sendRawMessage(const libremidi::message& message);
    void sendAllNotesOff(int channel);
    void setVolume(int channel, int volume);
private slots:
    void handleMidiMessage(const libremidi::message& message);
private:
    JackClient *jackClient;
    bool itsNote(const libremidi::message& message);
};

#endif // MIDICLIENT_H
