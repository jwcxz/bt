import math, threading, time

class Metronome(threading.Thread):
    timestep = None;
    tempo = None;
    tick_increment = None;
    ticker = 0;
    rx_beat_counter = 0;
    beatfn = None;

    enabled = False;
    running = False;
    synced = False;

    cfg = {
            'do_phaselock': True,
            'sync_wait':    True
            };



    def __init__(self, tempo, beatfn=None, timestep=.01, *args, **kwargs):
        threading.Thread.__init__(self);
        self.timestep = timestep;
        self.beatfn = beatfn;

        self.m_stop();
        self.set_tempo(tempo);

        for key in kwargs:
            self.cfg[key] = kwargs[key];


    def set_tempo(self, tempo):
        newtempo = float(tempo);
        if self.running:
            self.m_stop();
            self.tempo = newtempo;
            self.calc_tick_increment();
            self.m_start();
        else:
            self.tempo = newtempo;
            self.calc_tick_increment();


    def m_start(self):
        self.enabled = True;
        if not self.running:
            self.ticker = 0;
            self.rx_beat_counter = 0;
            self.running = True;


    def m_stop(self):
        self.running = False;
        self.synced = False;
   

    def m_restart(self):
        self.m_stop();
        self.m_start();


    def calc_tick_increment(self):
        # calculate the fraction of a beat that a tick represents
        self.tick_increment = self.timestep * (self.tempo * 1/60.);


    def run(self):
        # run metronome 
        self.m_start();

        while self.enabled:
            while self.enabled and not self.running:
                # yield and wait
                time.sleep(0);

            while self.running:
                if self.cfg['sync_wait']:
                    while not self.synced: time.sleep(0);

                _ = self.ticker;
                self.ticker += self.tick_increment;
                
                if self.beatfn and int(_) < int(self.ticker):
                    self.beatfn((self.ticker, self.rx_beat_counter));

                time.sleep(self.timestep);


    def receive_beat(self, probability):
        # add to received beat counter
        self.rx_beat_counter += 1;

        # calculate beat offset
        beat_offset = self.ticker - self.rx_beat_counter;

        # adjust phase to be closer to received beat based on probability that
        # the received beat was in fact a beat
        if self.do_phaselock:
            self.ticker = (    probability ) * self.rx_beat_counter + \
                          (1 - probability ) * self.ticker;

        return beat_offset;


    def get_beat_count(self):
        return (int(self.ticker), self.rx_beat_counter);


    def get_tempo(self):
        return self.tempo;


    def stop(self):
        self.m_stop();
        self.enabled = False;
