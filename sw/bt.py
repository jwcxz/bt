#!/usr/bin/env python2

import sys

import metronome

if __name__ == "__main__":
    m_tracker = metronome.Metronome(int(sys.argv[1]));

    def beat_inject(beatcount):
        print m_tracker.get_beat_count(), m_tracker.receive_beat(1.0);

    m_injector = metronome.Metronome(int(sys.argv[2]), beat_inject);

    m_tracker.start();
    print "started tracker";

    m_injector.start();
    print "started injector";

    raw_input();

    m_tracker.stop();
    m_injector.stop();
