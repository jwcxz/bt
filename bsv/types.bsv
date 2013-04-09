import FixedPoint::*;
import Vector::*;

typedef 16 NumMetronomes;
typedef 8 PhaseNSize;
typedef 8 PhaseDSize;

typedef Vector#(NumMetronomes, t) MetArr#(type t);

typedef Int#(14) AudioSample;

typedef UInt#(8) Tempo;
typedef FixedPoint(PhaseNSize, PhaseDSize) PhaseErr;

typedef struct {
    MetArr#(Tempo),
    MetArr#(PhaseErr)
} MetBankOutput deriving (Bits);
