import Types::*;
import FIRFilter::*;
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

    //FIRFilter fir <- mkFIRFilter(fir_coeffs);
    BeatClassifier bc <- mkBeatClassifier();
    MetArr#(Metronome) mb <- genWithM(mkMetronome);

    FIFOF#(TopLvlOut) bt_info <- mkSizedFIFOF(valueof(NumMetronomes));

    Reg#(Bool) sync_next <- mkReg(False);
    Reg#(Bool) sync_this <- mkReg(False);

    Reg#(BeatGuess) beat_guess <- mkReg(0);
    Reg#(UInt#(TLog#(TAdd#(NumMetronomes,1)))) mb_out_count <- mkReg(0);


    /*
    rule fir_to_bc (True);
        let x <- fir.response.get();
        bc.request.put(x);
    endrule
    */


    Reg#(PulserCount) mpc <- mkReg(0);
    rule pulser(True);
        if (mpc != fromInteger(pulser_count_max)) begin
            mpc <= mpc + 1;
        end else begin
            mpc <= 0;
            for (Integer m=0; m<valueof(NumMetronomes); m=m+1) begin
                mb[m].pulse();
            end
        end
    endrule


    rule beat_injector_start(mb_out_count == fromInteger(0));
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

    rule beat_injector_cont(mb_out_count > fromInteger(0) &&
                            mb_out_count < fromInteger(valueof(NumMetronomes)));
        let x <- mb[mb_out_count].inject_beat(beat_guess);
        if (sync_this) bt_info.enq(make_output(x));

        if ( mb_out_count == fromInteger(valueof(TSub#(NumMetronomes, 1))) ) begin
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
