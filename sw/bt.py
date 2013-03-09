#!/usr/bin/env python2

import metronome

if __name__ == "__main__":
    m_tracker = metronome.Metronome(140);

    def beat_inject(beatcount):
        print m_tracker.get_beat_count(), m_tracker.inject_beat(1.0);

    m_injector = metronome.Metronome(141, beat_inject);

    m_tracker.start();
    print "started tracker";

    m_injector.start();
    print "started injector";

    raw_input();

    m_tracker.stop();
    m_injector.stop();
