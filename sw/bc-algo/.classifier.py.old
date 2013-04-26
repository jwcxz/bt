#!/usr/bin/env python2

import injector, sys
import numpy as np

class BeatClassifier:
    cfg = {
            'framerate'  : 44100,
            'windowsize' : .001,
            'threshhold' : .5,
            'beat_decay' : .5,
            'none_decay' : .5
        };

    p = {
            'winlen' : None,
            'midlo'  : None,
            'midhi'  : None
        };

    buf = [];


    def __init__(self):
        pass;

    def set_params(self, *args, **kwargs):
        for k in kwargs.keys():
            self.cfg[k] = kwargs[k];

        self.calc_winlength();
        self.calc_midrange();
        self.clear_buf();

    def calc_winlength(self):
        self.p['winlen'] = int(self.cfg['framerate'] * self.cfg['windowsize']);

    def calc_midrange(self):
        lo = self.p['winlen'];
        hi = lo + self.p['winlen'] - 1;
        self.p['midlo'] = lo;
        self.p['midhi'] = hi;

    def clear_buf(self):
        self.buf = [0]*(3*self.p['winlen']);

    def update_buf(self, sample):
        self.buf.pop(0);
        self.buf.append(sample);

    def inject(self, sample):
        # take average of sample (not the best thing in the world to do in
        # general, especially when the left and right channels are 180 degrees
        # out of phase)
        sample = sum(sample)/len(sample);

        # add to buffer
        self.update_buf(sample);

        # compute sliding window averages
        avgs = self.sw_avg();

        print avgs

    def sw_avg(self):
        # 0 1 2 3 4 5
        # 2 3
        #   2 3
        #     2 3
        #       2 3
        #         2 3

        avgs = [];
        mid = self.buf[self.p['midlo']:self.p['midhi']+1]
        mid = np.array(mid);

        for base in xrange(0, self.p['midhi'] + 2):
            win = self.buf[base:base+self.p['winlen']];
            win = np.array(win);
            avgs.append( np.absolute(np.sum(mid * win)) );

        return avgs;


if __name__ == "__main__":

    bc = BeatClassifier();

    if len(sys.argv) > 1:
        injector = injector.SampleInjector(sys.argv[1], bc.inject);
        bc.set_params(framerate=injector.get_framerate());
        injector.start();
        print "Enter to stop...";
        raw_input();
        injector.stop();
        injector.destroy();

    else:
        bc.set_params(framerate=1, windowsize=2);
        for i in xrange(5):
            bc.inject([i]);
        for i in xrange(5):
            bc.inject([4-i]);
