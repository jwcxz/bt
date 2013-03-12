#!/usr/bin/env python2

import sys

import metronome, bank

if __name__ == "__main__":
    target_tempo = float(sys.argv[1]);

    #mbank = bank.MetronomeBank(13, narrow_field=False);
    mbank = bank.MetronomeBank(26, narrow_field=True);


    def beat_inject(beatcount):
        print "-------"
        mbank.inject_beat(1.0);
        perrs = mbank.get_phase_errors();
        min_p = None;
        for p in perrs:
            if min_p == None or abs(p[1]) < min_p[1]:
                min_p = (p[0], abs(p[1]));
            print " %3.3f: %f" %(p[0], p[1]);

        print "BEST ESTIMATE: %3.5f [%f]" %(min_p[0], min_p[1]);


    m_injector = metronome.Metronome(target_tempo, beat_inject);

    mbank.start_metronomes();
    m_injector.start();

    raw_input();

    mbank.stop_metronomes();

    m_injector.stop();
