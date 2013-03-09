import math, threading, time

class Metronome(threading.Thread):
    tpb = None
    tpb_floor_affinity = None;
    tpb_floor_choices = None;
    timestep = None;
    phaselock = True;
    tempo = None;
    tick_counter = 0;
    beat_counter = [0, 0];
    beatfn = None;

    enabled = False;
    running = False;


    def __init__(self, tempo, beatfn=None, phaselock=True, timestep=.01):
        threading.Thread.__init__(self);
        self.phaselock = phaselock;
        self.timestep = timestep;
        self.beatfn = beatfn;

        self.m_stop();
        self.set_tempo(tempo);


    def set_tempo(self, tempo):
        newtempo = float(tempo);
        if self.running:
            self.m_stop();
            self.tempo = newtempo;
            self.calc_ticks_per_beat();
            self.m_start();
        else:
            self.tempo = newtempo;
            self.calc_ticks_per_beat();


    def m_start(self):
        self.enabled = True;
        if not self.running:
            self.tick_counter = 0;
            self.beat_counter = [0, 0];
            self.running = True;


    def m_stop(self):
        self.running = False;
    

    def m_restart(self):
        self.m_stop();
        self.m_start();


    def calc_ticks_per_beat(self):
        # calculate ticks per beat with linear correction

        # full floating point calculation
        tpb_flt = 1/(self.timestep * (self.tempo * 1/60.));
        self.tpb = (math.floor(tpb_flt), tpb_flt, math.ceil(tpb_flt));

        # the ratio of the number of times choosing floor(tpb_flt) to the
        # number of times choosing ceil(tpb_flt) should match
        # tbp_flt-floor(tpb_flt)
        self.tpb_floor_affinity = tpb_flt - math.floor(tpb_flt);

        # reset actual floor-to-ceiling ratio 
        self.tpb_floor_choices = [0, 1];

        print "---"
        print self.tpb
        print self.tpb_floor_affinity;
        print "==="


    def get_ticks_per_beat(self):
        if not self.tpb or not self.tpb_floor_affinity or not self.tpb_floor_choices:
            self.calc_ticks_per_beat();

        fcratio = float(self.tpb_floor_choices[0]) / \
                  float(self.tpb_floor_choices[1]);

        if fcratio <= self.tpb_floor_affinity:
            # choose floor
            self.tpb_floor_choices[0] += 1;
            self.tpb_floor_choices[1] += 1;
            return self.tpb[0];
        
        else:
            # choose ceiling
            self.tpb_floor_choices[1] += 1;
            return self.tpb[1];


    def run(self):
        # run metronome 
        self.m_start();

        while self.enabled:
            while self.enabled and not self.running:
                # yield and wait
                time.sleep(0);

            while self.running:
                if self.tick_counter >= self.get_ticks_per_beat():
                    self.beat_counter[0] += 1;

                    if self.beatfn: self.beatfn(self.beat_counter);
                    #print "! %d" % self.beat_counter[0];

                    self.tick_counter = 0;
                else:
                    self.tick_counter += 1;

                time.sleep(self.timestep);


    def inject_beat(self, probability):
        # add to received beat counter
        self.beat_counter[1] += 1;

        # calculate beat offset
        i = float(self.beat_counter[1] - self.beat_counter[0]);
        f = self.tick_counter / self.tpb[1];

        # adjust phase to be closer to received beat based on probability that
        # the received beat was in fact a beat
        if self.phaselock:
            #self.tick_counter = 0*probability + self.tick_counter*(1-probability);
            self.tick_counter *= (1 - probability);
            self.beat_counter[0] = self.beat_counter[1];

        return i + f;


    def get_beat_count(self):
        return self.beat_counter;


    def stop(self):
        self.m_stop();
        self.enabled = False;
