#!/usr/bin/env python2

import sys

import metronome, bank, injector, beatclassifier

if __name__ == "__main__":
    mbank = bank.MetronomeBank(81, narrow_field=False);

    def beat_inject(p):
        print "-------"
        mbank.inject_beat(p);
        perrs = mbank.get_phase_errors();
        min_p = None;
        for p in perrs:
            if min_p == None or abs(p[1]) < min_p[1]:
                min_p = (p[0], abs(p[1]));
            print " %3.3f: %f" %(p[0], p[1]);

        print "BEST ESTIMATE: %3.5f [%f] => %d BPM" %(min_p[0], min_p[1], round(min_p[0]));
        

    bc = beatclassifier.BeatClassifier(beat_inject);
    sinjector = injector.SampleInjector(sys.argv[1], bc.receive_sample);

    print "Starting metronomes...";
    mbank.start_metronomes();

    print "Starting sample injector...";
    sinjector.start();

    print "Starting beat classifier...";
    bc.start();

    raw_input();

    print "Stopping metronomes...";
    mbank.stop_metronomes();

    print "Stopping beat classifier...";
    bc.stop();

    print "Stopping injector...";
    sinjector.stop();
    sinjector.destroy();

    print "Done!";


    """
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

        print "BEST ESTIMATE: %3.5f [%f] => %d BPM" %(min_p[0], min_p[1], round(min_p[0]));


    m_injector = metronome.Metronome(target_tempo, beat_inject,
            sync_wait=False, do_phaselock=False);

    mbank.start_metronomes();
    m_injector.start();

    raw_input();

    mbank.stop_metronomes();

    m_injector.stop();
    """
