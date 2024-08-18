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
    Q_PROPERTY(bool cc READ cc WRITE setCc NOTIFY ccChanged)
    Q_PROPERTY(bool pc READ pc WRITE setPc NOTIFY pcChanged)
    Q_PROPERTY(int rowOutputChannel READ rowOutputChannel WRITE setRowOutputChannel NOTIFY rowOutputChannelChanged)
public:

    enum LayersSet {
        Upper = 0,
        Lower = 1,
        Pedal = 2
    };
    Q_ENUM(LayersSet)

    explicit MidiClient(QObject *parent = nullptr);
    MidiPortModel* inputPorts() const { return m_inputPorts; }
    MidiPortModel* outputPorts() const { return m_outputPorts; }
    bool isOutputPortConnected() const {
        return jackClient && jackClient->midiout && jackClient->midiout->is_port_connected();
    }

signals:
    void outputPortConnectionChanged();
    void channelActivated(int channel);
    void ccChanged();
    void pcChanged();
    void rowOutputChannelChanged();

public slots:
    Q_INVOKABLE void sendNoteOn(int channel, int note, int velocity);
    Q_INVOKABLE void sendControlChange(int channel, int control, int value);
    Q_INVOKABLE void sendPitchBend(int channel, int value);
    Q_INVOKABLE void sendRawMessage(const libremidi::message& message);
    Q_INVOKABLE void sendAllNotesOff(int channel);
    Q_INVOKABLE void sendMsbLsbPc(int channel, int msb, int lsb, int pc);
    Q_INVOKABLE void setVolume(int channel, int volume);
    Q_INVOKABLE void setMasterVolume(int volume);
    Q_INVOKABLE void setReverb(int channel, int reverb);
    Q_INVOKABLE void getIOPorts();
    Q_INVOKABLE void makeConnection(QVariant inputPorts,QVariant outputPorts);
    Q_INVOKABLE void  makeDisconnect();
    void checkOutputPortConnection();
    Q_INVOKABLE void setLayerEnabled(LayersSet set, int layer, bool enabled);
    bool cc() const;
    bool pc() const;
    void setCc(bool cc);
    void setPc(bool pc);

    int rowOutputChannel() const;
    void setRowOutputChannel(int channel);


private slots:
    void handleMidiMessage(const libremidi::message& message);
private:
    JackClient *jackClient;
    bool itsNote(const libremidi::message& message);
    MidiPortModel *m_inputPorts;
    MidiPortModel *m_outputPorts;
    bool m_lastOutputPortStatus = false;

    bool m_cc;
    bool m_pc;

    int m_rowoutputchannel;

    QList<int> m_enabledLayersUpper;
    QList<int> m_enabledLayersPedal;
    QList<int> m_enabledLayersLower;
};

#endif // MIDICLIENT_H
