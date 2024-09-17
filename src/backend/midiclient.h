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
    Q_PROPERTY(int masterVolume READ masterVolume WRITE setMasterVolume NOTIFY masterVolumeChanged)
    Q_PROPERTY(QMap<int, int> octaves READ octaves NOTIFY octavesChanged)

    Q_PROPERTY(bool capturingLowNote READ isCapturingLowNote WRITE setCapturingLowNote NOTIFY capturingLowNoteChanged)
    Q_PROPERTY(bool capturingHighNote READ isCapturingHighNote WRITE setCapturingHighNote NOTIFY capturingHighNoteChanged)
    Q_PROPERTY(QString noteRange READ noteRange NOTIFY noteRangeChanged)
    Q_PROPERTY(int currentChannel READ currentChannel WRITE setCurrentChannel NOTIFY currentChannelChanged)
    Q_PROPERTY(QVariantMap channelRanges READ channelRanges NOTIFY channelRangesChanged)
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
    void masterVolumeChanged();
    void octavesChanged();

    void capturingLowNoteChanged();
    void capturingHighNoteChanged();
    void noteRangeChanged();
    void currentChannelChanged();
    void channelRangesChanged();
public slots:
    Q_INVOKABLE void sendNoteOn(int channel, int note, int velocity);
    Q_INVOKABLE void sendControlChange(int channel, int control, int value);
    Q_INVOKABLE void sendPitchBend(int channel, int value);
    Q_INVOKABLE void sendRawMessage(const libremidi::message& message);
    Q_INVOKABLE void sendAllNotesOff();
    Q_INVOKABLE void sendMsbLsbPc(int channel, int msb, int lsb, int pc);
    Q_INVOKABLE void setVolume(int channel, int volume);
    Q_INVOKABLE void  sendNotesOff(int channel);
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
    int setNoteOctave(int channel,int note);
    int rowOutputChannel() const;
    void setRowOutputChannel(int channel);

    int masterVolume();
    void setMasterVolume(int volume);

    Q_INVOKABLE int octave(int channel) const;
    Q_INVOKABLE void setOctave(int channel, int octave);
    QMap<int, int> octaves() const;

    Q_INVOKABLE void setChannelRange(int channel, int lowNote, int highNote);
    bool isCapturingLowNote() const { return m_capturingLowNote; }
    void setCapturingLowNote(bool capturing);
    bool isCapturingHighNote() const { return m_capturingHighNote; }
    void setCapturingHighNote(bool capturing);
    QString noteRange() const { return m_noteRange; }
    Q_INVOKABLE void updateNoteRange();
    Q_INVOKABLE void setCurrentChannel(int channel);
    Q_INVOKABLE int currentChannel() const { return m_currentChannel; }

    Q_INVOKABLE QVariantMap channelRanges() const;



private slots:
    void handleMidiMessage(const libremidi::message& message);

private:
    JackClient *jackClient;
    bool itsNote(const libremidi::message& message);
    bool itsVolumeCC(const libremidi::message& message);
    MidiPortModel *m_inputPorts;
    MidiPortModel *m_outputPorts;
    bool m_lastOutputPortStatus = false;

    bool m_cc;
    bool m_pc;
    int m_masterVolume;
    int m_rowoutputchannel;

    QList<int> m_enabledLayersUpper;
    QList<int> m_enabledLayersPedal;
    QList<int> m_enabledLayersLower;

    QMap<int, int> m_octaves;

    QMap<int, QPair<int, int>> m_channelRanges;  // Maps channel to (lowNote, highNote) pair

    bool isNoteInRange(int channel, int note);
    QString noteNumberToName(int noteNumber) const;

    bool m_capturingLowNote = false;
    bool m_capturingHighNote = false;
    int m_lowNote = -1;
    int m_highNote = -1;
    QString m_noteRange;
    int m_currentChannel = 0;  // Added to keep track of the current channel
};

#endif // MIDICLIENT_H
