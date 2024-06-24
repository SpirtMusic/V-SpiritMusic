#ifndef MIDICLIENT_H
#define MIDICLIENT_H

#include <QObject>
#include <backend/jackclient.h>
#include <backend/midiutils.h>
#include <backend/midiportmodel.h>
#include <QTimer>

class MidiClient  : public QObject
{
    Q_OBJECT  // Add this macro
    Q_PROPERTY(MidiPortModel* inputPorts READ inputPorts CONSTANT)
    Q_PROPERTY(MidiPortModel* outputPorts READ outputPorts CONSTANT)
    Q_PROPERTY(bool isOutputPortConnected READ isOutputPortConnected NOTIFY outputPortConnectionChanged)
public:
    explicit MidiClient(QObject *parent = nullptr);
    MidiPortModel* inputPorts() const { return m_inputPorts; }
    MidiPortModel* outputPorts() const { return m_outputPorts; }
    bool isOutputPortConnected() const {
        return jackClient && jackClient->midiout && jackClient->midiout->is_port_connected();
    }

signals:
    void outputPortConnectionChanged();
    void channelActivated(int channel);
public slots:
    Q_INVOKABLE void sendNoteOn(int channel, int note, int velocity);
    Q_INVOKABLE void sendControlChange(int channel, int control, int value);
    Q_INVOKABLE void sendPitchBend(int channel, int value);
    Q_INVOKABLE void sendRawMessage(const libremidi::message& message);
    Q_INVOKABLE void sendAllNotesOff(int channel);
    Q_INVOKABLE void setVolume(int channel, int volume);
    Q_INVOKABLE void getIOPorts();
    Q_INVOKABLE void makeConnection(QVariant inputPorts,QVariant outputPorts);
    Q_INVOKABLE void  makeDisconnect();
    void checkOutputPortConnection();
private slots:
    void handleMidiMessage(const libremidi::message& message);
private:
    JackClient *jackClient;
    bool itsNote(const libremidi::message& message);
    MidiPortModel *m_inputPorts;
    MidiPortModel *m_outputPorts;
    bool m_lastOutputPortStatus = false;
};

#endif // MIDICLIENT_H
