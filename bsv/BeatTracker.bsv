import Types::*;
import BeatClassifier::*;
import Metronome::*;


import ClientServer::*;
import GetPut::*;

import FixedPoint::*;
import Vector::*;

import FIFO::*;

interface BeatTracker;
    method Action putSampleInput(AudioSample in);
    method ActionValue#(TopLvlOut) getBeatInfo();
endinterface

module mkBeatTracker(BeatTracker);

    BeatClassifier bc <- mkBeatClassifier();
    MetArr#(Metronome) mb <- replicateM(mkMetronome);
    //MetronomeBankController mbc <- mkMetronomeBankController();

    //FIFOF#(TopLvlOut) bt_info <- mkFIFOF1();
    //Reg#(TopLvlOut) bt_info <- mkReg(0);
    FIFO#(TopLvlOut) bt_info <- mkFIFO1();

    Reg#(Bool) init_done <- mkReg(False);

    rule init(!init_done);
        mb[0].set_tempo(calc_tempo_increment(120));
        mb[1].set_tempo(calc_tempo_increment(140));
        mb[2].set_tempo(calc_tempo_increment(80));
        mb[3].set_tempo(calc_tempo_increment(90));
        init_done <= True;
    endrule


    Reg#(MetronomePulseCount) mpc <- mkReg(0);
    rule metronome_pulser(init_done);
        if (mpc != fromInteger(metronome_pulse_count_max)) begin
            mpc <= mpc + 1;
        end else begin
            mpc <= 0;
            for (Integer m=0; m<valueof(NumMetronomes); m=m+1) begin
                mb[m].pulse();
            end
        end
    endrule


    rule beat_injector(init_done);
        let beat_info <- bc.response.get();

        for (Integer m=0; m<valueof(NumMetronomes); m=m+1) begin
            let x <- mb[m].inject_beat(beat_info);

            if (m==0) begin
                bt_info.enq(pack(x));
            end
        end
    endrule


    method Action putSampleInput(AudioSample x);
        bc.request.put(x);
    endmethod

    method ActionValue#(TopLvlOut) getBeatInfo();
        //let x <- bc.response.get();
        let x = bt_info.first();
        bt_info.deq();
        return x;
    endmethod


endmodule
