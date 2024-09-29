#include "jackclient.h"
#include <QDebug>
JackClient::JackClient(QObject *parent)
    : QObject{parent}, midiin(nullptr),midiout(nullptr),midiout_raw(nullptr),
    m_volume(1.0f), pan(0.0f)
{
    auto callback = [&](int port, const libremidi::message& message) {
        // qDebug() << message;
        emit midiMessageReceived(message);
        //  midiout[port].send_message(message);
    };

    // Create a JACK client which will be shared across objects
    jack_status_t status{};
    handle.reset(jack_client_open("VSpiritMusic", JackNoStartServer, &status));

    if (!handle)
        throw std::runtime_error("Could not start JACK client");
    // Create an observer configuration
    libremidi::observer_configuration conf{
        .input_added = [&](const libremidi::input_port& id) {
            qDebug() << "Input connected: " << id.port_name;
        },
        .input_removed = [&](const libremidi::input_port& id) {
            qDebug() << "Input removed: " << id.port_name;
        },
        .output_added = [&](const libremidi::output_port& id) {
            qDebug() << "Output connected: " << id.port_name;
        },
        .output_removed = [&](const libremidi::output_port& id) {
            qDebug() << "Output removed: " << id.port_name;
        }
    };

    // Create an observer using the configuration
    observer = libremidi::observer{conf, libremidi::jack_observer_configuration{.context = handle.get()}};
    setupAudioPorts();
    jack_set_process_callback(handle.get(), jack_callback, this);
    jack_activate(handle.get());


    // Create our configuration
    auto api_input_config = libremidi::jack_input_configuration{
        .context = handle.get(),
        .set_process_func = [this](libremidi::jack_callback cb) {
            midiin_callback = std::move(cb);
        }
    };

    auto api_output_config = libremidi::jack_output_configuration{
        .context = handle.get(),
        .set_process_func = [this](libremidi::jack_callback cb) {
            midiout_callback = std::move(cb);
        }
    };
    auto api_output_raw_config = libremidi::jack_output_configuration{
        .context = handle.get(),
        .set_process_func = [this](libremidi::jack_callback cb) {
            midiout_callback_raw = std::move(cb);
        }
    };


    midiin = std::make_unique<libremidi::midi_in>(
        libremidi::input_configuration{
            .on_message = [=](const libremidi::message& msg) { callback(0, msg); },
            .ignore_sysex = false
        },
        api_input_config
        );
    // midiin->open_virtual_port("Input: 1");

    midiout = std::make_unique<libremidi::midi_out>(
        libremidi::output_configuration{},
        api_output_config
        );
    midiout_raw = std::make_unique<libremidi::midi_out>(
        libremidi::output_configuration{},
        api_output_raw_config
        );
    //  midiout->open_virtual_port("Output: 1");
}

void JackClient::setupAudioPorts() {
    input_left = jack_port_register(handle.get(), "input_L", JACK_DEFAULT_AUDIO_TYPE, JackPortIsInput, 0);
    input_right = jack_port_register(handle.get(), "input_R", JACK_DEFAULT_AUDIO_TYPE, JackPortIsInput, 0);
    output_left = jack_port_register(handle.get(), "output_L", JACK_DEFAULT_AUDIO_TYPE, JackPortIsOutput, 0);
    output_right = jack_port_register(handle.get(), "output_R", JACK_DEFAULT_AUDIO_TYPE, JackPortIsOutput, 0);

    if (!input_left || !input_right || !output_left || !output_right) {
        throw std::runtime_error("Failed to register JACK audio ports");
    }
}

int JackClient::jack_callback(jack_nframes_t cnt, void *ctx)
{
    auto& self = *(JackClient*)ctx;

    // Process the midi input
    self.midiin_callback.callback(cnt);

    jack_default_audio_sample_t *in_left = (jack_default_audio_sample_t*)jack_port_get_buffer(self.input_left, cnt);
    jack_default_audio_sample_t *in_right = (jack_default_audio_sample_t*)jack_port_get_buffer(self.input_right, cnt);
    jack_default_audio_sample_t *out_left = (jack_default_audio_sample_t*)jack_port_get_buffer(self.output_left, cnt);
    jack_default_audio_sample_t *out_right = (jack_default_audio_sample_t*)jack_port_get_buffer(self.output_right, cnt);

    float leftGain = std::min(1.0f, 1.0f - self.pan);
    float rightGain = std::min(1.0f, 1.0f + self.pan);

    for (jack_nframes_t i = 0; i < cnt; i++) {
        out_left[i] = in_left[i] * self.m_volume * leftGain;
        out_right[i] = in_right[i] * self.m_volume * rightGain;
    }

    // Process the midi output
    self.midiout_callback.callback(cnt);
    self.midiout_callback_raw.callback(cnt);
    return 0;
}
void JackClient::sendMidiMessage(int port, const libremidi::message& message)
{
    midiout->send_message(message);
}
void JackClient::send_MidiMessage(const libremidi::message message)
{
    midiout->send_message(message);
}
void JackClient::setVolume(float newVolume)
{
    m_volume = newVolume;
}

void JackClient::setPan(float newPan)
{
    pan = newPan;
}
float JackClient::volume()
{
    return m_volume;
}
