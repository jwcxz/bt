import FixedPoint::*;
import Real::*;
import Vector::*;
import FShow::*;


Real clk_freq = 25e6;
Real min_tempo = 120;

typedef 60 NumMetronomes;

// number of samples to store in energy calculation buffer
typedef 11 SampleCountSize;

// metronome pulse frequency: clk_freq / 2**MetronomePulseCountSize
typedef 9 PulserCountSize;

// resolution of metronome counter
typedef 22 MetronomeCounterSize;



// Top Level
typedef Vector#(NumMetronomes, t) MetArr#(type t);
Integer num_metronomes = valueof(NumMetronomes);

typedef UInt#(PulserCountSize) PulserCount;
Integer pulser_count_max = valueof(TSub#(TExp#(PulserCountSize), 1));

typedef Bit#(8) TopLvlOut;



// Beat Classifier
typedef Bit#(28) StereoAudioSample;
typedef Bit#(28) BeatGuess;

typedef struct {
    Int#(14) left;
    Int#(14) right;
} AudioSample deriving (Bits, Eq);

typedef Int#(28) SampleEnergy;
typedef UInt#(SampleCountSize) SampleCount;
Integer sample_count_max = valueof(TSub#(TExp#(SampleCountSize), 1));


// FixedAndBuffered
typedef 64 FBAvgEnergyLength;
Integer avg_energy_length = valueof(FBAvgEnergyLength);

typedef 28 FBVISize;
typedef 4  FBVFSize;

typedef Int#(FBVISize) FBEnergy;
typedef FixedPoint#(TAdd#(1, FBVISize), FBVFSize) FBFPEnergy;


// Variance
typedef 64 VAvgEnergyLength;
typedef UInt#(TAdd#(TLog#(VAvgEnergyLength),1)) VEnergyStage;
typedef 28 VVISize;
typedef 16  VVFSize;

typedef Int#(VVISize) VEnergy;
typedef Int#(TDiv#(VVISize,2))  VHEnergy;

typedef VEnergy  VVariance;
typedef Int#(TMul#(VVISize,2))  VVarEnergy;

typedef FixedPoint#(TAdd#(1, TMul#(VVISize,2)), VVFSize) VLinReg;




// Metronome
typedef UInt#(MetronomeCounterSize) MetronomeCounter;
Integer metronome_counter_max = valueof(TSub#(TExp#(MetronomeCounterSize), 1));

typedef MetronomeCounter TempoIncrement;
typedef MetronomeCounter PhaseErr;



// Functions
function TempoIncrement calc_tempo_increment (Real tempo);
    Real pulse_freq = clk_freq * 1/fromInteger(pulser_count_max+1);
    Real increment = tempo * 1/60.0 * (1/pulse_freq) * fromInteger(metronome_counter_max+1);
    
    TempoIncrement ti = fromInteger(round(increment));
    return ti;
endfunction


function TopLvlOut make_output(PhaseErr x);
    return pack(x)[valueof(MetronomeCounterSize)-1:valueof(MetronomeCounterSize)-8];
endfunction
