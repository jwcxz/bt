import Types::*;
import BeatClassifier::*;
import Metronome::*;


import ClientServer::*;
import GetPut::*;

import FixedPoint::*;
import Vector::*;

import FIFO::*;
import FIFOF::*;

interface BeatTracker;
    method Action q_sync();
    method Action putSampleInput(StereoAudioSample in);
    method ActionValue#(TopLvlOut) getBeatInfo();
endinterface

module mkBeatTracker(BeatTracker);

    BeatClassifier bc <- mkBeatClassifier();
    //MetArr#(Metronome) mb <- replicateM(mkMetronome);
    MetArr#(Metronome) mb <- genWithM(mkMetronome);

    FIFOF#(TopLvlOut) bt_info <- mkSizedFIFOF(valueof(NumMetronomes));

    Reg#(Bool) init_done <- mkReg(False);
    Reg#(Bool) sync_next <- mkReg(False);
    Reg#(Bool) sync_this <- mkReg(False);

    Reg#(BeatGuess) beat_guess <- mkReg(0);
    Reg#(UInt#(TLog#(TAdd#(NumMetronomes,1)))) mb_out_count <- mkReg(0);

    rule init(!init_done);
        /* {{{
        mb[0].set_tempo(calc_tempo_increment(150));
        mb[1].set_tempo(calc_tempo_increment(140));
        mb[2].set_tempo(calc_tempo_increment(130));
        mb[3].set_tempo(calc_tempo_increment(120));
        // }}} */

        /* {{{
        for (Integer m=0; m<valueof(NumMetronomes); m=m+1) begin
            mb[m].set_tempo(calc_tempo_increment(min_tempo+fromInteger(m)));
        end
        // }}} */

        init_done <= True;
    endrule


    Reg#(PulserCount) mpc <- mkReg(0);
    rule pulser(init_done);
        if (mpc != fromInteger(pulser_count_max)) begin
            mpc <= mpc + 1;
        end else begin
            mpc <= 0;
            for (Integer m=0; m<valueof(NumMetronomes); m=m+1) begin
                mb[m].pulse();
            end
        end
    endrule


    rule beat_injector_start(init_done && mb_out_count == fromInteger(0));
        let beat_guess_i <- bc.response.get();
        beat_guess <= beat_guess_i;

        for (Integer m=0 ; m < valueof(NumMetronomes) ; m=m+1) begin
            mb[m].inject_beat(beat_guess_i);
        end
        
        sync_this <= sync_next;
        sync_next <= False;

        /*
        if (valueof(NumMetronomes) > 1) begin
            mb_out_count <= fromInteger(1);
        end
        */
        mb_out_count <= fromInteger(1);
    endrule

    rule beat_injector_cont(init_done &&
                            mb_out_count > fromInteger(0) &&
                            mb_out_count < fromInteger(valueof(TAdd#(NumMetronomes,1))));


        let x <- mb[mb_out_count-1].get_phase_err();

        if (sync_this) begin
            bt_info.enq(make_output(x));
        end

        if ( mb_out_count == fromInteger(valueof(NumMetronomes)) ) begin
            mb_out_count <= fromInteger(0);
        end else begin
            mb_out_count <= mb_out_count + fromInteger(1);
        end
    endrule


    method Action q_sync() if (!sync_next);
        sync_next <= True;
    endmethod


    method Action putSampleInput(StereoAudioSample in);
        Int#(14) l = unpack(in[27:14]);
        Int#(14) r = unpack(in[13:0]);
        AudioSample a = AudioSample{ left: l, right: r };
        bc.request.put(a);
        //fir.request.put(a);
    endmethod


    method ActionValue#(TopLvlOut) getBeatInfo();
        let x = bt_info.first;
        bt_info.deq();
        return x;
    endmethod


endmodule
