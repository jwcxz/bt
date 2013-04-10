import threading, time

class BeatClassifier(threading.Thread):
    injfn = None;

    samplerate = 44100; # reasonable default
    timestep = None;
    
    bufsize = None;
    samplebuf = [];

    last_beat = 0;

    cfg = {
            'bufseconds': 2,
            'avg_decay': .25,
            'beat_thresh': 1.5
        };


    def __init__(self, injfn, *args, **kwargs):
        threading.Thread.__init__(self);
        for key in kwargs: self.cfg[key] = kwargs[key];
        self.set_samplerate(self.samplerate);
        self.injfn = injfn;


    def set_samplerate(self, samplerate):
        self.samplerate = samplerate;
        self.timestep = 1/float(samplerate);
        self.bufsize = self.__nsamples(self.cfg['bufseconds']);
        blen = len(self.samplebuf);

        if blen < self.bufsize:
            self.samplebuf += [0]*(self.bufsize - blen);
        elif blen > self.bufsize:
            self.samplebuf = self.samplebuf[:self.bufsize];


    def receive_sample(self, sample):
        # TODO: for now, only consider one channel, even if it's stereo
        self.samplebuf.append(sample[0]);


    def run(self):
        self.enabled = True;

        while self.enabled:
            # apply algorithm
            self.classifier_round();
            self.samplebuf.pop(0);
            time.sleep(self.timestep);


    def stop(self):
        self.enabled = False;


    local_energy = [0, 0];
    average_energy = 0;
    def classifier_round(self):
        N_L = 4096;
        F = 1.3;
        alpha = 0.5;

        sample = self.samplebuf[0];

        # compute energy
        energy = sample ** 2;

        self.local_energy[0] += 1;
        self.local_energy[1] += energy;

        if self.local_energy[0] == N_L:
            # compare against average energy and report
            if self.local_energy[1] >= F * self.average_energy:
                self.injfn(1.0);
                #print "UNS! %f %f" % (self.local_energy[1], self.average_energy);

            # update average energy
            self.average_energy = alpha * self.average_energy + \
                                  (1-alpha) * self.local_energy[1];

            self.local_energy[0] = 0;
            self.local_energy[1] = 0.;

    
    running_avg = 0;
    def __old__classifier_round(self):
        # running average for baseline volume
        self.running_avg = (1 - self.cfg['avg_decay'])*self.running_avg + \
                            (self.cfg['avg_decay'])*((self.samplebuf[-1])**2);

        # look for vu pulse shape lasting about 15ms
        # highest tempo would be like 180bpm, so a beat every .3 sec
        
        # take sliding window of about 15ms and look for significantly higher
        # average of absolute values than normal

        self.last_beat += 1;

        # only look for a beat if it's been over 75ms since the last beat
        if self.last_beat >= self.__nsamples(0.075):
            window_size = int(self.__nsamples(0.015));
            window = self.samplebuf[-window_size:];
            window_average = sum([s**2 for s in window])/float(window_size);

            if window_average >= self.cfg['beat_thresh'] * self.running_avg:
                self.injfn(1.0);
                self.last_beat = 0;


    def __nsamples(self, seconds):
        return self.samplerate * seconds;
