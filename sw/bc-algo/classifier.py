#!/usr/bin/env python2

import injector, sys
import numpy as np

class BeatClassifier:
    cfg = {
            'framerate'  : 44100,
            'windowsize' : .001,
            'threshhold' : .5,
            'beat_decay' : .5,
            'none_decay' : .5,
            'N_L' : 4096,
            'F' : 1.3,
            'alpha' : 0.5
        };

    p = {
            'winlen' : None,
            'midlo'  : None,
            'midhi'  : None
        };

    local_energy = [0, 0];
    average_energy = 0;


    def __init__(self):
        pass;

    def set_params(self, *args, **kwargs):
        for k in kwargs.keys():
            self.cfg[k] = kwargs[k];

    def inject(self, sample):
        # take average of sample (not the best thing in the world to do in
        # general, especially when the left and right channels are 180 degrees
        # out of phase)
        sample = sum(sample)/len(sample);

        # compute energy
        energy = sample ** 2;

        self.local_energy[0] += 1;
        self.local_energy[1] += energy;

        if self.local_energy[0] == self.cfg['N_L']:
            # compare against average energy and report
            if self.local_energy[1] >= self.cfg['F'] * self.average_energy:# or \
               #self.local_energy[1] <= 1/self.cfg['F'] * self.average_energy:
                   print "UNS! %f %f" % (self.local_energy[1], self.average_energy);

            # update average energy
            self.average_energy = self.cfg['alpha'] * self.average_energy + \
                                  (1-self.cfg['alpha']) * self.local_energy[1];

            self.local_energy[0] = 0;
            self.local_energy[1] = 0.;



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
        bc.set_params(framerate=1, windowsize=2, N_L=2);
        for i in xrange(5):
            bc.inject([i]);
        for i in xrange(5):
            bc.inject([4-i]);
