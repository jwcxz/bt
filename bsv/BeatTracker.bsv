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
    method Action putSampleInput(AudioSample in);
    method ActionValue#(TopLvlOut) getBeatInfo();
endinterface

module mkBeatTracker(BeatTracker);

    BeatClassifier bc <- mkBeatClassifierTest();
    MetArr#(Metronome) mb <- replicateM(mkMetronome);
    //MetronomeBankController mbc <- mkMetronomeBankController();

    //FIFOF#(TopLvlOut) bt_info <- mkFIFOF1();
    //Reg#(TopLvlOut) bt_info <- mkReg(0);
    //FIFO#(TopLvlOut) bt_info <- mkFIFO1();
    FIFOF#(TopLvlOut) bt_info <- mkSizedFIFOF(valueof(NumMetronomes));

    Reg#(Bool) init_done <- mkReg(False);
    Reg#(Bool) sync_next <- mkReg(False);
    Reg#(Bool) sync_this <- mkReg(False);

    Reg#(BeatGuess) beat_guess <- mkReg(0);
    Reg#(UInt#(TLog#(TAdd#(NumMetronomes,1)))) mb_out_count <- mkReg(0);

    rule init(!init_done);
        /*
        mb[0].set_tempo(calc_tempo_increment(150));
        mb[1].set_tempo(calc_tempo_increment(140));
        mb[2].set_tempo(calc_tempo_increment(130));
        mb[3].set_tempo(calc_tempo_increment(120));
        // */

        //* {{{
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


    /* {{{
    rule beat_injector(init_done);
        BeatGuess beat_guess_i = fromInteger(0);

        if (mb_out_count == fromInteger(0)) begin
            beat_guess_i <- bc.response.get();
            beat_guess <= beat_guess_i;

            if (valueof(NumMetronomes) > 1) mb_out_count <= fromInteger(1);
        end else begin
            beat_guess_i = beat_guess;

            if ( mb_out_count == fromInteger(valueof(TSub#(NumMetronomes, 1))) ) begin
                mb_out_count <= fromInteger(0);
                sync_next <= False;
            end else begin
                mb_out_count <= mb_out_count + fromInteger(1);
            end
        end
        
        let x <- mb[mb_out_count].inject_beat(beat_guess_i);
        if (sync_next) bt_info.enq(make_output(x));
    endrule
    // }}} */


    /* {{{
    rule beat_injector_start(init_done && mb_out_count == fromInteger(0));
        let beat_guess_i <- bc.response.get();
        beat_guess <= beat_guess_i;
        mb_out_count <= fromInteger(1);
        sync_this <= sync_next;
        sync_next <= False;
    endrule

    rule beat_injector_cont(init_done &&
                            mb_out_count >  fromInteger(0) &&
                            mb_out_count <= fromInteger(num_metronomes));

        let x <- mb[mb_out_count-1].inject_beat(beat_guess);
        bt_info.enq(make_output(x));

        if ( mb_out_count == fromInteger(num_metronomes) ) begin
            mb_out_count <= fromInteger(0);
            //sync_this <= False;
        end else begin
            mb_out_count <= mb_out_count + fromInteger(1);
        end
    endrule
    // }}} */


    //* {{{
    rule beat_injector_start(init_done && mb_out_count == fromInteger(0));
        let beat_guess_i <- bc.response.get();
        beat_guess <= beat_guess_i;
        
        let x <- mb[0].inject_beat(beat_guess_i);
        if (sync_next) bt_info.enq(make_output(x));

        sync_this <= sync_next;
        sync_next <= False;

        if (valueof(NumMetronomes) > 1) begin
            mb_out_count <= fromInteger(1);
        end
    endrule

    rule beat_injector_cont(init_done &&
                            mb_out_count > fromInteger(0) &&
                            mb_out_count < fromInteger(valueof(NumMetronomes)));
        let x <- mb[mb_out_count].inject_beat(beat_guess);
        if (sync_this) bt_info.enq(make_output(x));

        if ( mb_out_count == fromInteger(valueof(TSub#(NumMetronomes, 1))) ) begin
            mb_out_count <= fromInteger(0);
        end else begin
            mb_out_count <= mb_out_count + fromInteger(1);
        end
    endrule
    // }}} */


    method Action q_sync() if (!sync_next);
        sync_next <= True;
    endmethod


    method Action putSampleInput(AudioSample x);
        bc.request.put(x);
    endmethod


    method ActionValue#(TopLvlOut) getBeatInfo();
        let x = bt_info.first;
        bt_info.deq();
        return x;
    endmethod


endmodule
