import Types::*;

import FIFO::*;

interface Metronome;
    method Action inject_beat(BeatGuess p);
    method Action pulse();
    method ActionValue#(PhaseErr) get_phase_err();
endinterface

module mkMetronome(Integer tempo_bpm_from_base, Metronome ifc);

    Real tempo_bpm = min_tempo + fromInteger(tempo_bpm_from_base);
    TempoIncrement increment = calc_tempo_increment(tempo_bpm);

    //FIFO#(MetronomeCounter) pefifo <- mkFIFO1();
    Reg#(PhaseErr) pe <- mkReg(0);

    Reg#(Bool) tick_pulse <- mkReg(False);

    Reg#(Bool) valid <- mkReg(True);

    Reg#(MetronomeCounter) counter <- mkReg(0);


    rule metronome_counter(valid && tick_pulse);
        counter <= counter + increment;
    endrule


    rule tick_pulse_off(valid && tick_pulse);
        tick_pulse <= False;
    endrule

    method Action pulse() if (valid && !tick_pulse);
        tick_pulse <= True;
    endmethod


    method Action inject_beat(BeatGuess p);
        // TODO: do something with the beatguess, but for now, ignore
        //counter <= fromInteger(0);

        Bit#(MetronomeCounterSize) cbits = pack(counter);
        Bit#(MetronomeCounterSize) nbits = {cbits[valueof(MetronomeCounterSize)-1],
                                            cbits[valueof(MetronomeCounterSize)-1:1]};
        counter <= unpack(nbits);

        //pefifo.enq(last_counter);
        pe <= counter;
    endmethod

    method ActionValue#(PhaseErr) get_phase_err();
        //let x = pefifo.first();
        //pefifo.deq();
        //return x;
        return pe;
    endmethod

endmodule
