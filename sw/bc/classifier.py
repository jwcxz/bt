#!/usr/bin/env python2

import injector, sys

class BeatClassifier:
    cfg = {
            'framerate'  : 44100,
            'windowsize' : .001,
            'threshhold' : .5,
            'beat_decay' : .5,
            'none_decay' : .5
        };

    p = {
            'winlen'   : None,
            'midrange' : None
        };

    buf = [];


    def __init__(self):
        pass;

    def set_params(*args, **kwargs):
        for k in kwargs.keys():
            self.cfg[k] = kwargs[k];

        self.calc_winlength();
        self.calc_midrange();
        self.clear_buf();

    def calc_winlength(self):
        self.p['winlen'] = self.cfg['framerate'] * self.cfg['windowsize'];

    def calc_midrange(self):
        lo = self.p['winlen']/2;
        hi = lo + self.p['winlen'] - 1;
        self.p['midrange'] = (lo, hi);

    def clear_buf(self):
        self.buf = [0]*(2*self.p['winlen']);

    def update_buf(self, sample):
        self.buf.pop(0);
        self.buf.append(sample);

    def inject(self, sample):
        # take average of sample (not the best thing in the world to do in
        # general, especially when the left and right channels are 180 degrees
        # out of phase)
        sample = sum(sample)/len(sample);





if __name__ == "__main__":

    bc = BeatClassifier();

    injector = SampleInjector(sys.argv[1], bc.inject);

    bc.set_params(injector.get_framerate());

    injector.start();

    print "Enter to stop...";
    raw_input()

    injector.stop();
    injector.destroy();
