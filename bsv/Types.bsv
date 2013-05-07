import FixedPoint::*;
import Real::*;
import Vector::*;
import FShow::*;


Real clk_freq = 25e6;
Real min_tempo = 80;

typedef 65 NumMetronomes;

// number of samples to store in energy calculation buffer
typedef 10 SampleCountSize;

// metronome pulse frequency: clk_freq / 2**MetronomePulseCountSize
typedef 9 PulserCountSize;

// resolution of metronome counter
typedef 22 MetronomeCounterSize;



// Top Level
typedef Bit#(28) StereoAudioSample;
typedef struct {
    Int#(14) left;
    Int#(14) right;
} AudioSample deriving (Bits, Eq);

typedef Vector#(NumMetronomes, t) MetArr#(type t);
Integer num_metronomes = valueof(NumMetronomes);

typedef UInt#(PulserCountSize) PulserCount;
Integer pulser_count_max = valueof(TSub#(TExp#(PulserCountSize), 1));

typedef Bit#(8) TopLvlOut;



// Beat Classifier
typedef 64 AvgEnergyLength;
typedef UInt#(TAdd#(TLog#(AvgEnergyLength),1)) EnergyStage;
Integer avg_energy_length = valueof(AvgEnergyLength);

typedef Int#(28) SampleEnergy;
typedef UInt#(SampleCountSize) SampleCount;
Integer sample_count_max = valueof(TSub#(TExp#(SampleCountSize), 1));


typedef Bit#(28) BeatGuess;

/* variance classifier types */
typedef 26 VISize;
typedef 16 VFSize;

typedef UInt#(VISize)           Energy;
typedef UInt#(TMul#(VISize,2))  SqEnergy;
typedef UInt#(TMul#(VISize,3))  CuEnergy;
typedef FixedPoint#(TAdd#(1, TMul#(VISize,3)), VFSize) LinReg;


// Metronome
typedef UInt#(MetronomeCounterSize) MetronomeCounter;
Integer metronome_counter_max = valueof(TSub#(TExp#(MetronomeCounterSize), 1));

typedef MetronomeCounter TempoIncrement;
typedef MetronomeCounter PhaseErr;



// Functions
function TempoIncrement calc_tempo_increment(Real tempo);
    Real pulse_freq = clk_freq * 1/fromInteger(pulser_count_max+1);
    Real increment = tempo * 1/60.0 * (1/pulse_freq) * fromInteger(metronome_counter_max+1);
    
    TempoIncrement ti = fromInteger(round(increment));
    return ti;
endfunction


function TopLvlOut make_output(PhaseErr x);
    return pack(x)[valueof(MetronomeCounterSize)-1:valueof(MetronomeCounterSize)-8];
endfunction


// FIR Filter
typedef 14 FIR_ISIZE;
typedef 16 FIR_FSIZE;
Vector#(13, FixedPoint#(FIR_ISIZE, FIR_FSIZE)) fir_coeffs =
    cons(fromReal(-0.04463417126993918),
    cons(fromReal(0.04910541101096455),
    cons(fromReal(0.06189674038815581),
    cons(fromReal(0.008906353853344689),
    cons(fromReal(-0.12587987298491263),
    cons(fromReal(-0.2765089776732705),
    cons(fromReal(0.6573385628582229),
    cons(fromReal(-0.2765089776732705),
    cons(fromReal(-0.12587987298491263),
    cons(fromReal(0.008906353853344689),
    cons(fromReal(0.06189674038815581),
    cons(fromReal(0.04910541101096455),
    cons(fromReal(-0.04463417126993918),
    nil)))))))))))));


