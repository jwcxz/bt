import FixedPoint::*;
import Real::*;
import Vector::*;
import FShow::*;

typedef 4 NumMetronomes;
typedef 8 PhaseNSize;
typedef 8 PhaseDSize;

// number of samples to store in energy calculation buffer
typedef 12 SampleCountSize;

// metronome pulse frequency: 50e6 / 2**MetronomePulseCountSize
typedef 12 MetronomePulseCountSize;

// resolution of metronome counter
typedef 20 MetronomeCounterSize;



// Top Level
typedef Vector#(NumMetronomes, t) MetArr#(type t);

typedef UInt#(MetronomePulseCountSize) MetronomePulseCount;
Integer metronome_pulse_count_max = valueof(TSub#(TExp#(MetronomePulseCountSize), 1));

typedef Bit#(MetronomeCounterSize) TopLvlOut;


// Beat Classifier
typedef Bit#(14) AudioSample;

typedef Int#(28) SampleEnergy;
typedef UInt#(SampleCountSize) SampleCount;
Integer sample_count_max = valueof(TSub#(TExp#(SampleCountSize), 1));

typedef Bit#(28) BeatGuess;



// Metronome
typedef UInt#(MetronomeCounterSize) MetronomeCounter;
Integer metronome_counter_max = valueof(TSub#(TExp#(MetronomeCounterSize), 1));

typedef MetronomeCounter TempoIncrement;
typedef MetronomeCounter PhaseErr;

//typedef FixedPoint#(PhaseNSize, PhaseDSize) PhaseErr;


typedef struct {
    MetArr#(TempoIncrement) tempos;
    MetArr#(PhaseErr) phase_errors;
} MetBankOutput deriving (Bits);



// Functions
function TempoIncrement calc_tempo_increment (Real tempo);
    Real pulse_freq = 50e6 * 1/fromInteger(metronome_pulse_count_max+1);
    Real increment = tempo * 1/60.0 * (1/pulse_freq) * fromInteger(metronome_counter_max+1);
    
    TempoIncrement ti = fromInteger(round(increment));
    return ti;
endfunction
