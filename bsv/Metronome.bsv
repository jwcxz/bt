import Types::*;

import FIFOF::*;

interface Metronome;
    method ActionValue#(PhaseErr) inject_beat(BeatGuess p);
    method Action pulse();
    method Action set_tempo(TempoIncrement t);
endinterface

function Metronome instantiate_metronome(Integer tempo_offset);
    real tempo = min_tempo + tempo_offset;
    return mkMetronome(tempo);
endfunction

module mkMetronome(Real tempo_bpm, Metronome ifc);

    TempoIncrement increment = calc_tempo_increment(tempo_bpm);

    Reg#(Bool) tick_pulse <- mkReg(False);

    Reg#(Bool) valid <- mkReg(False);

    Reg#(MetronomeCounter) counter <- mkReg(0);
    Reg#(MetronomeCounter) last_counter <- mkReg(0);


    rule metronome_counter(valid && tick_pulse);
        last_counter <= counter + increment;
        counter <= counter + increment;
    endrule


    rule tick_pulse_off(valid && tick_pulse);
        tick_pulse <= False;
    endrule

    method Action pulse() if (valid && !tick_pulse);
        tick_pulse <= True;
    endmethod


    method ActionValue#(PhaseErr) inject_beat(BeatGuess p);
        // TODO: do something with the beatguess, but for now, ignore
        counter <= fromInteger(0);
        return last_counter;
    endmethod


    method Action set_tempo(TempoIncrement t);
        valid <= True;
        increment <= t;
    endmethod

endmodule

module mkMetronome2(Metronome);

    Reg#(Bool) tick_pulse <- mkReg(False);

    Reg#(Bool) valid <- mkReg(False);

    Reg#(TempoIncrement) increment <- mkReg(0);
    Reg#(MetronomeCounter) counter <- mkReg(0);
    Reg#(MetronomeCounter) last_counter <- mkReg(0);

    FIFOF#(BeatGuess) new_beat <- mkFIFOF1();


    rule metronome_counter(valid && tick_pulse && !new_beat.notEmpty);
        last_counter <= counter + increment;
        counter <= counter + increment;
    endrule

    rule phase_correct(valid && !tick_pulse && new_beat.notEmpty);
        new_beat.deq();
        counter <= fromInteger(0);
    endrule


    rule tick_pulse_off(valid && tick_pulse);
        tick_pulse <= False;
    endrule

    method Action pulse() if (valid && !tick_pulse);
        tick_pulse <= True;
    endmethod


    method ActionValue#(PhaseErr) inject_beat(BeatGuess p);
        // TODO: do something with the beatguess, but for now, ignore
        //counter <= fromInteger(0);
        if (valid) begin
            new_beat.enq(p);
        end

        return last_counter;
    endmethod


    method Action set_tempo(TempoIncrement t);
        valid <= True;
        increment <= t;
    endmethod

endmodule
