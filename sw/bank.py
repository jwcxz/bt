import numpy as np
import metronome

class MetronomeBank:
    metronomes = None;
    phase_errors = None;
    generation = None;

    cfg = {
        'decay_phserr': .90,
        'gen_turnover': 10,
        'min_tempo_increment': .1,
        'range_squash_factor': 2,
        'narrow_field': True
          }

    def __init__(self, bank_size=20, tempo_min=60, tempo_max=180, *args, **kwargs):
        self.metronomes = [];
        phase_errors = [];
        for tempo in np.linspace(tempo_min, tempo_max, bank_size):
            self.metronomes.append( metronome.Metronome(tempo) );
            phase_errors.append( 0.0 );
        self.phase_errors = np.array(phase_errors);

        self.bank_size = bank_size;

        for key in kwargs: self.cfg[key] = kwargs[key];

    def inject_beat(self, probability):
        if not self.metronomes:
            return;

        # inject beat for all metronomes
        phase_errors = [];
        for m in self.metronomes:
            phase_errors.append( m.receive_beat(probability) );

        phase_errors = np.array(phase_errors);

        # update running averages
        self.phase_errors = (     self.cfg['decay_phserr'])*self.phase_errors + \
                            (1. - self.cfg['decay_phserr'])*phase_errors;

        # if we hit the generation limit, try to zoom in on new candidates
        # based on the phase error curve
        self.generation += 1;
        if self.generation == self.cfg['gen_turnover']:
            if self.cfg['narrow_field']:
                self.narrow_field();
            self.generation = 0;

    def get_phase_errors(self):
        out = [];
        for m, pe in zip(self.metronomes, self.phase_errors):
            out.append((m.get_tempo(), pe));

        return out;

    def start_metronomes(self):
        self.generation = 0;
        for m in self.metronomes:
            m.start();

    def stop_metronomes(self):
        for m in self.metronomes:
            m.stop();

    def narrow_field(self):
        # based on current phase errors, figure out new min and max tempos and
        # create a new bank of metronomes within that range

        # however only do this if the difference between any two existing
        # tempos is larger than min_tempo_increment
        if abs(self.metronomes[1].get_tempo() - \
               self.metronomes[0].get_tempo()) <= \
                    self.cfg['min_tempo_increment']:
            return;

        cur_range = self.metronomes[-1].get_tempo() - self.metronomes[0].get_tempo();
        
        # find crossover point
        cur_center = None;
        for i in xrange(len(self.metronomes)):
            if cur_center == None or abs(self.phase_errors[i]) < cur_center[0]:
                cur_center = (abs(self.phase_errors[i]),
                              self.metronomes[i].get_tempo());

        cur_center = cur_center[1];
        """
        for i in xrange(1, len(self.metronomes)):
            if self.phase_errors[i] >= 0 and self.phase_errors[i-1] < 0:
                cur_center = self.metronomes[i].get_tempo();
                break;
        """


        if cur_center == None:
            # no crossover found... TODO: try higher frequencies or something,
            # IDK
            return;

        else:
            new_range = cur_range/self.cfg['range_squash_factor'];
            new_tempos = np.linspace(max(0, cur_center-(new_range/2)),
                                     cur_center+(new_range/2),
                                     self.bank_size);

        for i in xrange(len(self.metronomes)):
            self.metronomes[i].set_tempo(new_tempos[i]);
            self.phase_errors[i] = 0.0;
